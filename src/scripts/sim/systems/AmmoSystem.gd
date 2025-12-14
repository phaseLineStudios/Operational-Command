class_name AmmoSystem
extends Node
## Centralized ammunition logistics for all units in a mission.
##
## Responsibilities:
## - Track per-unit ammo state (caps + current) and thresholds.
## - Consume ammo on fire; emit low/critical/empty signals.
## - In-field resupply: logistics units within radius transfer rounds over time
##   using their transfer rate; emits resupply started/completed.

## Emitted when current/cap <= low threshold.
signal ammo_low(unit_id: String)
## Emitted when current/cap <= critical threshold.
signal ammo_critical(unit_id: String)
## Emitted when current ammo hits zero.
signal ammo_empty(unit_id: String)
## Emitted when a logistics unit begins resupplying a recipient.
signal resupply_started(src_unit_id: String, dst_unit_id: String)
## Emitted when resupply finishes (recipient full OR stock exhausted).
signal resupply_completed(src_unit_id: String, dst_unit_id: String)
## Emitted when supplier runs out of ammunition stock.
signal supplier_exhausted(src_unit_id: String)

## Default caps/thresholds applied to newly registered units if missing.
@export var ammo_profile: AmmoProfile

# --- Internal state ---
var _units: Dictionary = {}  ## unit_id -> ScenarioUnit
var _positions: Dictionary = {}  ## unit_id -> Vector3 (world XZ; Y ignored)
var _logi: Dictionary = {}  ## unit_id -> bool (is logistics)
var _active_links: Dictionary = {}  ## dst_id -> src_id (current resupply pair)
var _xfer_accum: Dictionary = {}  ## dst_id -> float (carry fractional budget)


## Add to a group for convenient lookups.
func _ready() -> void:
	add_to_group("AmmoSystem")


# --- Public API: roster management ---


## Register a unit so AmmoSystem tracks it and applies defaults if missing.
func register_unit(su: ScenarioUnit) -> void:
	_units[su.id] = su

	# Initialize ammunition from equipment if available
	_init_ammunition_from_equipment(su)

	# Apply profile defaults for any missing values
	if ammo_profile:
		ammo_profile.apply_defaults_if_missing(su)

	_logi[su.id] = _is_logistics(su)


## Stop tracking a unit and tear down any active resupply links.
func unregister_unit(unit_id: String) -> void:
	_units.erase(unit_id)
	_positions.erase(unit_id)
	_logi.erase(unit_id)
	for dst in _active_links.keys().duplicate():
		if _active_links[dst] == unit_id or dst == unit_id:
			_active_links.erase(dst)
	_xfer_accum.erase(unit_id)


## Update a unit's world-space position (meters; XZ used, Y ignored).
func set_unit_position(unit_id: String, pos: Vector3) -> void:
	_positions[unit_id] = pos


## Retrieve the ScenarioUnit previously registered (or null if unknown).
func get_unit(unit_id: String) -> ScenarioUnit:
	return _units.get(unit_id, null)


# --- Public API: queries + consumption ---


## True if current/cap <= low threshold (and > 0).
func is_low(su: ScenarioUnit, t: String) -> bool:
	if su == null or su.unit == null:
		return false
	var cap := int(su.unit.ammunition.get(t, 0))
	if cap <= 0:
		return false
	var cur := int(su.state_ammunition.get(t, 0))
	return cur > 0 and float(cur) / float(cap) <= su.unit.ammunition_low_threshold


## True if current/cap <= critical threshold (and > 0).
func is_critical(su: ScenarioUnit, t: String) -> bool:
	if su == null or su.unit == null:
		return false
	var cap := int(su.unit.ammunition.get(t, 0))
	if cap <= 0:
		return false
	var cur := int(su.state_ammunition.get(t, 0))
	return cur > 0 and float(cur) / float(cap) <= su.unit.ammunition_critical_threshold


## True if current ammo is zero.
func is_empty(su: ScenarioUnit, t: String) -> bool:
	if su == null:
		return true
	return int(su.state_ammunition.get(t, 0)) <= 0


## Decrease ammo for `unit_id` of type `t` by `amount`.
## Returns true if ammo was consumed; false if blocked (missing type or empty).
func consume(unit_id: String, t: String, amount: int = 1) -> bool:
	var su: ScenarioUnit = _units.get(unit_id) as ScenarioUnit
	if su == null or not su.state_ammunition.has(t):
		return false

	var cur: int = int(su.state_ammunition.get(t, 0))
	if cur <= 0:
		su.state_ammunition[t] = 0
		emit_signal("ammo_empty", unit_id)
		return false

	var newv: int = max(0, cur - max(1, amount))
	su.state_ammunition[t] = newv

	if newv <= 0:
		emit_signal("ammo_empty", unit_id)
	elif is_critical(su, t):
		emit_signal("ammo_critical", unit_id)
	elif is_low(su, t):
		emit_signal("ammo_low", unit_id)
	return true


# --- Main loop ---


## Start links for needy units and transfer rounds along active links.
func tick(delta: float) -> void:
	for uid in _units.keys():
		if _active_links.has(uid):
			continue
		var dst: ScenarioUnit = _units[uid]
		if not _needs_ammo(dst):
			continue
		var src_id := _pick_link_for(dst)
		if src_id != "":
			_begin_link(src_id, uid)
	_transfer_tick(delta)


# --- Internals: selection, radius, transfer ---


## True if src is within its transfer radius of dst.
func _within_radius(src: ScenarioUnit, dst: ScenarioUnit) -> bool:
	if not _positions.has(src.id) or not _positions.has(dst.id):
		return false
	var a: Vector3 = _positions[src.id]
	var b: Vector3 = _positions[dst.id]
	return a.distance_to(b) <= max(src.unit.supply_transfer_radius_m, 0.0)


## True if the unit should act as a logistics source.
func _is_logistics(su: ScenarioUnit) -> bool:
	if su.unit.throughput is Dictionary and not su.unit.throughput.is_empty():
		return true
	if (
		su.unit.equipment_tags is Array
		and (
			su.unit.equipment_tags.has("AMMO_PALLET")
			or su.unit.equipment_tags.has("AMMUNITION_PALLET")
			or su.unit.equipment_tags.has("LOGISTICS")
		)
	):
		return true
	return false


## True if any ammo type is below its cap, unit is alive, and is stationary.
func _needs_ammo(su: ScenarioUnit) -> bool:
	# Don't resupply dead units
	if su.state_strength <= 0:
		return false
	# Only resupply stationary units
	if su.move_state() != ScenarioUnit.MoveState.IDLE:
		return false
	for t in su.unit.ammunition.keys():
		if int(su.state_ammunition.get(t, 0)) < int(su.unit.ammunition[t]):
			return true
	return false


## True if unit has any stock left to transfer.
func _has_stock(su: ScenarioUnit) -> bool:
	for t in su.unit.throughput.keys():
		if int(su.unit.throughput[t]) > 0:
			return true
	return false


## Pick a logistics source within radius that has stock (simple first-match).
func _pick_link_for(dst: ScenarioUnit) -> String:
	for sid in _units.keys():
		if sid == dst.id:
			continue
		if not _logi.get(sid, false):
			continue
		var src: ScenarioUnit = _units[sid]
		# Don't use dead units as suppliers
		if src.state_strength <= 0:
			continue
		# Only use stationary units as suppliers
		if src.move_state() != ScenarioUnit.MoveState.IDLE:
			continue
		if not _has_stock(src):
			continue
		if not _within_radius(src, dst):
			continue
		return sid
	return ""


## Begin a resupply link from `src_id` to `dst_id`.
func _begin_link(src_id: String, dst_id: String) -> void:
	_active_links[dst_id] = src_id
	_xfer_accum[dst_id] = 0.0
	emit_signal("resupply_started", src_id, dst_id)


## Finish an active resupply link for `dst_id`.
func _finish_link(dst_id: String) -> void:
	var src_id: String = _active_links.get(dst_id, "")
	if src_id != "":
		emit_signal("resupply_completed", src_id, dst_id)
	_active_links.erase(dst_id)
	_xfer_accum.erase(dst_id)


## Transfer rounds for all active links using a fractional-rate accumulator so
## low rates still work at high frame rates (e.g., 20 rps @ 60 FPS).
func _transfer_tick(delta: float) -> void:
	for dst_id in _active_links.keys().duplicate():
		var src: ScenarioUnit = _units.get(_active_links[dst_id]) as ScenarioUnit
		var dst: ScenarioUnit = _units.get(dst_id) as ScenarioUnit
		if src == null or dst == null:
			_finish_link(dst_id)
			continue
		# Break link if either unit moves
		if (
			src.move_state() != ScenarioUnit.MoveState.IDLE
			or dst.move_state() != ScenarioUnit.MoveState.IDLE
		):
			_finish_link(dst_id)
			continue
		if not _within_radius(src, dst) or not _has_stock(src):
			_finish_link(dst_id)
			continue

		var acc: float = float(_xfer_accum.get(dst_id, 0.0))
		acc += max(0.0, src.unit.supply_transfer_rate) * delta
		var transferable: int = int(floor(acc))
		if transferable <= 0:
			_xfer_accum[dst_id] = acc
			continue

		var remaining: int = transferable
		var transferred: int = 0

		for t in dst.unit.ammunition.keys():
			if remaining <= 0:
				break
			var cap: int = int(dst.unit.ammunition[t])
			var cur: int = int(dst.state_ammunition.get(t, 0))
			if cur >= cap:
				continue
			var need: int = cap - cur
			var stock: int = int(src.unit.throughput.get(t, 0))
			if stock <= 0:
				continue

			var xfer: int = min(need, min(stock, remaining))
			if xfer <= 0:
				continue

			dst.state_ammunition[t] = cur + xfer
			src.unit.throughput[t] = stock - xfer
			remaining -= xfer
			transferred += xfer

		_xfer_accum[dst_id] = acc - float(transferred)

		var out_of_stock := not _has_stock(src)
		if not _needs_ammo(dst) or out_of_stock:
			if out_of_stock:
				emit_signal("supplier_exhausted", _active_links[dst_id])
			_finish_link(dst_id)


## Initialize ammunition capacities from equipment.
## Scans equipment.weapons and calculates ammo capacity for each AmmoTypes.
## [param su] ScenarioUnit to initialize
func _init_ammunition_from_equipment(su: ScenarioUnit) -> void:
	if not su.unit.equipment or not su.unit.equipment.has("weapons"):
		return

	var weapons: Dictionary = su.unit.equipment.get("weapons", {})
	if weapons.is_empty():
		return

	# Map AmmoTypes enum to ammo type string keys
	const AMMO_TYPE_KEYS := [
		"SMALL_ARMS",  # 0
		"HEAVY_WEAPONS",  # 1
		"AUTOCANNON",  # 2
		"TANK_GUN",  # 3
		"AT_ROCKET",  # 4
		"ATGM",  # 5
		"MORTAR_AP",  # 6
		"MORTAR_SMOKE",  # 7
		"MORTAR_ILLUM",  # 8
		"ARTILLERY_AP",  # 9
		"ARTILLERY_SMOKE",  # 10
		"ARTILLERY_ILLUM",  # 11
		"ENGINEER_MUN"  # 12
	]

	# Calculate ammo capacity for each type based on equipment
	var ammo_caps: Dictionary = {}
	for weapon_name in weapons.keys():
		var weapon_data: Dictionary = weapons[weapon_name]
		var ammo_type_index: int = int(weapon_data.get("ammo", -1))
		var quantity: int = int(weapon_data.get("type", 0))

		# Skip if no ammo type or quantity
		if ammo_type_index < 0 or ammo_type_index >= AMMO_TYPE_KEYS.size():
			continue
		if quantity <= 0:
			continue

		var ammo_key: String = AMMO_TYPE_KEYS[ammo_type_index]

		# Sum up quantities for this ammo type
		if not ammo_caps.has(ammo_key):
			ammo_caps[ammo_key] = 0
		ammo_caps[ammo_key] += quantity

	# Only update ammunition if we found any weapon equipment
	if not ammo_caps.is_empty():
		# Initialize ammunition dict if empty
		if su.unit.ammunition.is_empty():
			su.unit.ammunition = {}

		# Initialize state_ammunition dict if empty
		if su.state_ammunition.is_empty():
			su.state_ammunition = {}

		# Set capacities from equipment
		for ammo_key in ammo_caps.keys():
			su.unit.ammunition[ammo_key] = ammo_caps[ammo_key]
			# Set current state to full capacity if not already set
			if not su.state_ammunition.has(ammo_key):
				su.state_ammunition[ammo_key] = ammo_caps[ammo_key]

		LogService.debug(
			"Initialized ammo from equipment for %s: %s" % [su.id, str(ammo_caps)], "AmmoSystem.gd"
		)
