class_name FuelSystem
extends Node
## Mission-scoped fuel consumption and refueling based on ScenarioUnit movement.
##
## Responsibilities
## - Track per-unit fuel state and ScenarioUnit positions.
## - Drain fuel per second (idle) and per meter (movement),
##   with optional terrain and slope multipliers.
## - Emit threshold events and immobilize at empty by pausing ScenarioUnit.
## - Proximity refuel from tanker units with throughput["fuel"] stock.
## - Provide a speed multiplier so movement can slow at CRITICAL and stop at EMPTY.Y.

## Threshold and refuel lifecycle signals
signal fuel_low(unit_id: String)
signal fuel_critical(unit_id: String)
signal fuel_empty(unit_id: String)
signal refuel_started(src_unit_id: String, dst_unit_id: String)
signal refuel_completed(src_unit_id: String, dst_unit_id: String)

## Mobility signals
signal unit_immobilized_fuel_out(unit_id: String)
signal unit_mobilized_after_refuel(unit_id: String)

## Defaults and terrain hooks
@export var fuel_profile: FuelProfile
## Optional terrain data for surface and slope multipliers.
@export var terrain_data: TerrainData
## Movement penalty at CRITICAL fuel. 1.0 means no penalty.
@export_range(0.1, 1.0, 0.05) var critical_speed_mult: float = 0.6

## Registered units and state (typed dictionaries to avoid Variant)
var _su: Dictionary[String, ScenarioUnit] = {}  ## unit_id -> ScenarioUnit
var _fuel: Dictionary[String, UnitFuelState] = {}  ## unit_id -> UnitFuelState
var _pos: Dictionary[String, Vector2] = {}  ## unit_id -> latest position_m
var _prev: Dictionary[String, Vector2] = {}  ## unit_id -> previous tick position_m
var _immobilized: Dictionary[String, bool] = {}  ## unit_id -> immobilized due to empty fuel

## Active refuel links and fractional carry-over
var _active_links: Dictionary[String, String] = {}  ## dst_id -> src_id
var _xfer_accum: Dictionary[String, float] = {}  ## dst_id -> fractional fuel budget


func _ready() -> void:
	## Allow discovery via group.
	add_to_group("FuelSystem")


## Public API


func register_scenario_unit(su: ScenarioUnit, state: UnitFuelState = null) -> void:
	## Register a ScenarioUnit together with its UnitFuelState. Subscribes to movement signals.
	if su == null or su.id == "":
		return
	_su[su.id] = su
	var s: UnitFuelState = state if state != null else UnitFuelState.new()
	if fuel_profile:
		fuel_profile.apply_defaults_if_missing(s)
	_fuel[su.id] = s
	_pos[su.id] = su.position_m
	_prev[su.id] = su.position_m
	_immobilized[su.id] = false

	## Keep positions fresh via movement signals and pass uid using bind().
	su.move_progress.connect(_on_move_progress.bind(su.id))
	su.move_started.connect(_on_move_started.bind(su.id))
	su.move_arrived.connect(_on_move_arrived.bind(su.id))
	su.move_blocked.connect(_on_move_blocked.bind(su.id))
	su.move_paused.connect(_on_move_paused.bind(su.id))
	su.move_resumed.connect(_on_move_resumed.bind(su.id))


func unregister_unit(unit_id: String) -> void:
	## Unregister a unit and drop any active refuel links.
	_su.erase(unit_id)
	_fuel.erase(unit_id)
	_pos.erase(unit_id)
	_prev.erase(unit_id)
	_immobilized.erase(unit_id)
	_xfer_accum.erase(unit_id)
	for dst_key in _active_links.keys().duplicate():
		var dst: String = dst_key as String
		if _active_links[dst] == unit_id or dst == unit_id:
			_active_links.erase(dst)


func get_fuel_state(unit_id: String) -> UnitFuelState:
	## Return the UnitFuelState for a unit, or null if not present.
	return _fuel.get(unit_id) as UnitFuelState


func is_low(unit_id: String) -> bool:
	## True if current fraction <= low threshold and > critical threshold.
	var s: UnitFuelState = _fuel.get(unit_id) as UnitFuelState
	if s == null or s.fuel_capacity <= 0.0:
		return false
	var r: float = s.ratio()
	return s.state_fuel > 0.0 and r <= s.fuel_low_threshold and r > s.fuel_critical_threshold


func is_critical(unit_id: String) -> bool:
	## True if current fraction <= critical threshold and > 0.
	var s: UnitFuelState = _fuel.get(unit_id) as UnitFuelState
	if s == null or s.fuel_capacity <= 0.0:
		return false
	return s.state_fuel > 0.0 and s.ratio() <= s.fuel_critical_threshold


func is_empty(unit_id: String) -> bool:
	## True if current fuel is zero.
	var s: UnitFuelState = _fuel.get(unit_id) as UnitFuelState
	if s == null:
		return false
	return s.state_fuel <= 0.0


func speed_mult(unit_id: String) -> float:
	## Movement uses this multiplier: 1.0 normal, critical_speed_mult at CRITICAL, 0.0 at EMPTY.
	if is_empty(unit_id):
		return 0.0
	if is_critical(unit_id):
		return critical_speed_mult
	return 1.0


func tick(delta: float) -> void:
	## Main simulation entry. Call from SimWorld each frame.
	_consume_tick(delta)
	_refuel_tick(delta)


## Movement signal handlers


func _on_move_progress(pos_m: Vector2, _eta: float, uid: String) -> void:
	_pos[uid] = pos_m


func _on_move_started(_dest: Vector2, uid: String) -> void:
	var su: ScenarioUnit = _su.get(uid) as ScenarioUnit
	if su != null:
		_pos[uid] = su.position_m
		_prev[uid] = su.position_m


func _on_move_arrived(_dest: Vector2, uid: String) -> void:
	var su: ScenarioUnit = _su.get(uid) as ScenarioUnit
	if su != null:
		_pos[uid] = su.position_m


func _on_move_blocked(_reason: String, uid: String) -> void:
	var su: ScenarioUnit = _su.get(uid) as ScenarioUnit
	if su != null:
		_pos[uid] = su.position_m


func _on_move_paused(uid: String) -> void:
	var su: ScenarioUnit = _su.get(uid) as ScenarioUnit
	if su != null:
		_pos[uid] = su.position_m


func _on_move_resumed(uid: String) -> void:
	var su: ScenarioUnit = _su.get(uid) as ScenarioUnit
	if su != null:
		_pos[uid] = su.position_m


## Fuel drain


func _consume_tick(delta: float) -> void:
	## Apply idle burn and distance-based burn. Update thresholds and immobilization.
	for key in _fuel.keys():
		var uid: String = key as String
		var su: ScenarioUnit = _su.get(uid) as ScenarioUnit
		var st: UnitFuelState = _fuel.get(uid) as UnitFuelState
		if su == null or st == null:
			continue

		var before: float = st.state_fuel

		var now_pos: Vector2 = su.position_m
		var prev_pos: Vector2 = (_prev.get(uid, now_pos) as Variant) as Vector2
		_pos[uid] = now_pos

		var idle_burn: float = max(0.0, st.fuel_idle_rate_per_s) * max(delta, 0.0)

		var dist_m: float = now_pos.distance_to(prev_pos)
		var move_mult: float = _terrain_slope_multiplier(prev_pos, now_pos)
		var move_burn: float = max(0.0, st.fuel_move_rate_per_m) * dist_m * move_mult

		var total: float = idle_burn + move_burn
		if total > 0.0:
			st.state_fuel = max(0.0, st.state_fuel - total)

		_prev[uid] = now_pos
		_check_thresholds(uid, before, st.state_fuel, su)


func _check_thresholds(uid: String, before: float, after: float, su: ScenarioUnit) -> void:
	## Emit threshold events and pause or resume the ScenarioUnit when crossing 0.
	var st: UnitFuelState = _fuel.get(uid) as UnitFuelState
	if st == null:
		return
	var cap: float = max(1.0, st.fuel_capacity)
	var before_r: float = clamp(before / cap, 0.0, 1.0)
	var after_r: float = clamp(after / cap, 0.0, 1.0)

	if after <= 0.0 and before > 0.0:
		emit_signal("fuel_empty", uid)
		if not _immobilized.get(uid, false):
			_immobilized[uid] = true
			su.pause_move()
			emit_signal("unit_immobilized_fuel_out", uid)
	elif (
		after_r <= st.fuel_critical_threshold
		and before_r > st.fuel_critical_threshold
		and after > 0.0
	):
		emit_signal("fuel_critical", uid)
	elif after_r <= st.fuel_low_threshold and before_r > st.fuel_low_threshold and after > 0.0:
		emit_signal("fuel_low", uid)

	if before <= 0.0 and after > 0.0:
		if _immobilized.get(uid, false):
			_immobilized[uid] = false
			su.resume_move()
			emit_signal("unit_mobilized_after_refuel", uid)


## Terrain and slope


func _terrain_slope_multiplier(a: Vector2, b: Vector2) -> float:
	## Combine surface and slope multipliers. Returns 1.0 if no terrain data is provided.
	if terrain_data == null:
		return 1.0
	var surface_mult: float = 1.0
	var slope_mult: float = 1.0

	# Surface multiplier from terrain areas
	var surfaces: Array = terrain_data.surfaces
	if surfaces != null and surfaces.size() > 0:
		var mid: Vector2 = (a + b) * 0.5
		surface_mult = _surface_mult_at(mid)

	# Slope multiplier from elevation texture
	var img: Image = terrain_data.elevation
	if img != null and not img.is_empty():
		var k: float = fuel_profile.slope_k if fuel_profile != null else 0.25
		var dz_norm: float = _elevation_delta_norm(a, b)
		slope_mult = 1.0 + max(0.0, k) * clamp(dz_norm, 0.0, 1.0)

	return max(0.1, surface_mult * slope_mult)


func _surface_mult_at(p_m: Vector2) -> float:
	## Returns a surface movement multiplier at the given world position in meters.
	var best: float = 1.0
	var best_z: float = -INF
	var arr: Array = terrain_data.surfaces
	for it in arr:
		if typeof(it) != TYPE_DICTIONARY:
			continue
		var dict: Dictionary = it as Dictionary
		var poly: PackedVector2Array = dict.get("points", PackedVector2Array())
		if poly.is_empty():
			continue

		# Build a quick AABB in meters that covers the polygon.
		var aabb: Rect2 = Rect2(Vector2.INF, Vector2.ZERO)
		for v in poly:
			if aabb.position == Vector2.INF:
				aabb = Rect2(v, Vector2.ZERO)
			else:
				# Godot 4: Rect2.expand(point)
				aabb = aabb.expand(v)

		if not aabb.has_point(p_m):
			continue

		if Geometry2D.is_point_in_polygon(p_m, poly):
			var brush: TerrainBrush = dict.get("brush") as TerrainBrush
			if brush != null:
				var z: float = float(brush.z_index)
				if z >= best_z:
					best_z = z
					best = min(best, brush.movement_multiplier(TerrainBrush.MoveProfile.TRACKED))
	return max(0.25, best)


func _elevation_delta_norm(a: Vector2, b: Vector2) -> float:
	## Approximate normalized elevation delta between two points using the elevation Image.
	var img: Image = terrain_data.elevation
	if img == null or img.is_empty():
		return 0.0

	var w_m: float = max(1.0, float(terrain_data.width_m))
	var h_m: float = max(1.0, float(terrain_data.height_m))
	var px_w: float = float(img.get_width())
	var px_h: float = float(img.get_height())

	# Convert meters to pixel indices, explicitly typed.
	var ax: int = clamp(int(round(a.x / w_m * px_w)), 0, int(px_w) - 1)
	var ay: int = clamp(int(round(a.y / h_m * px_h)), 0, int(px_h) - 1)
	var bx: int = clamp(int(round(b.x / w_m * px_w)), 0, int(px_w) - 1)
	var by: int = clamp(int(round(b.y / h_m * px_h)), 0, int(px_h) - 1)

	var ca: float = img.get_pixel(ax, ay).r
	var cb: float = img.get_pixel(bx, by).r
	return abs(cb - ca)


## Refuel logic


func _is_tanker(u: UnitData) -> bool:
	## A unit acts as a tanker if it has a positive throughput["fuel"] or a logistics tag.
	if u == null:
		return false
	if u.throughput is Dictionary and int(u.throughput.get("fuel", 0)) > 0:
		return true
	if (
		u.equipment_tags is Array
		and (u.equipment_tags.has("FUEL_TANKER") or u.equipment_tags.has("LOGISTICS"))
	):
		return true
	return false


func _needs_fuel(su: ScenarioUnit) -> bool:
	## True if the unit is not full.
	var st: UnitFuelState = _fuel.get(su.id) as UnitFuelState
	if st == null:
		return false
	return st.state_fuel < st.fuel_capacity


func _has_stock(su: ScenarioUnit) -> bool:
	## True if the source unit still has fuel stock to transfer.
	var u: UnitData = su.unit
	if u == null or not (u.throughput is Dictionary):
		return false
	return int(u.throughput.get("fuel", 0)) > 0


func _within_radius(src: ScenarioUnit, dst: ScenarioUnit) -> bool:
	## True if destination is within the source's supply transfer radius in meters.
	var r: float = max(0.0, src.unit.supply_transfer_radius_m)
	return src.position_m.distance_to(dst.position_m) <= r


func _pick_link_for(dst: ScenarioUnit) -> String:
	## Choose the nearest eligible tanker for a destination unit. Returns the src unit_id or "".
	var best_src: String = ""
	var best_d: float = INF
	for key in _su.keys():
		var id: String = key as String
		var src: ScenarioUnit = _su[id] as ScenarioUnit
		if src == null or src.id == dst.id:
			continue
		if not _is_tanker(src.unit):
			continue
		if not _within_radius(src, dst):
			continue
		if not _has_stock(src):
			continue
		var d: float = src.position_m.distance_to(dst.position_m)
		if d < best_d:
			best_d = d
			best_src = src.id
	return best_src


func _begin_link(src_id: String, dst_id: String) -> void:
	## Start a refuel link.
	_active_links[dst_id] = src_id
	_xfer_accum[dst_id] = 0.0
	emit_signal("refuel_started", src_id, dst_id)


func _finish_link(dst_id: String) -> void:
	## Finish and signal the end of a refuel link.
	var src_id: String = _active_links.get(dst_id, "")
	if src_id != "":
		emit_signal("refuel_completed", src_id, dst_id)
	_active_links.erase(dst_id)
	_xfer_accum.erase(dst_id)


func _refuel_tick(delta: float) -> void:
	## Create links where needed, then transfer fuel over time while in range.
	for key in _su.keys():
		var dst_id: String = key as String
		if _active_links.has(dst_id):
			continue
		var dst: ScenarioUnit = _su[dst_id] as ScenarioUnit
		if dst == null or not _needs_fuel(dst):
			continue
		var src_id: String = _pick_link_for(dst)
		if src_id != "":
			_begin_link(src_id, dst_id)

	for key2 in _active_links.keys().duplicate():
		var dst_id2: String = key2 as String
		var src_id2: String = _active_links[dst_id2]
		var src: ScenarioUnit = _su.get(src_id2) as ScenarioUnit
		var dst2: ScenarioUnit = _su.get(dst_id2) as ScenarioUnit
		if src == null or dst2 == null:
			_finish_link(dst_id2)
			continue
		if not _within_radius(src, dst2):
			_finish_link(dst_id2)
			continue

		var rate: float = max(0.0, src.unit.supply_transfer_rate)
		var budget: float = rate * max(delta, 0.0) + float(_xfer_accum.get(dst_id2, 0.0))

		var st_dst: UnitFuelState = _fuel.get(dst_id2) as UnitFuelState
		if st_dst == null:
			_finish_link(dst_id2)
			continue

		var cap: float = st_dst.fuel_capacity
		var cur: float = st_dst.state_fuel
		var need: float = max(0.0, cap - cur)
		var stock: float = float(int(src.unit.throughput.get("fuel", 0)))

		var transferred: float = min(need, min(stock, budget))
		if transferred > 0.0:
			st_dst.state_fuel = min(cap, cur + transferred)
			src.unit.throughput["fuel"] = int(stock - transferred)
			_xfer_accum[dst_id2] = budget - transferred
		else:
			_xfer_accum[dst_id2] = budget

		if not _needs_fuel(dst2) or not _has_stock(src):
			_finish_link(dst_id2)


## Directly add fuel to a unit (UI/depot use). Returns amount actually added.
func add_fuel(uid: String, amount: float) -> float:
	var st: UnitFuelState = _fuel.get(uid) as UnitFuelState
	if st == null or amount <= 0.0:
		return 0.0
	var su: ScenarioUnit = _su.get(uid) as ScenarioUnit
	var cap: float = st.fuel_capacity
	var cur: float = st.state_fuel
	var add: float = min(amount, max(0.0, cap - cur))
	if add <= 0.0:
		return 0.0
	var before: float = cur
	st.state_fuel = cur + add
	_check_thresholds(uid, before, st.state_fuel, su)
	return add


## Compact UI snapshot for overlays / panels.
func fuel_debug(uid: String) -> Dictionary:
	var st: UnitFuelState = _fuel.get(uid) as UnitFuelState
	if st == null:
		return {"percent": null, "state": "n/a", "mult": 1.0, "penalty_pct": 0}
	var pct: int = int(round(st.ratio() * 100.0))
	var tag := "NORMAL"
	if is_empty(uid):
		tag = "EMPTY"
	elif is_critical(uid):
		tag = "CRITICAL"
	elif is_low(uid):
		tag = "LOW"
	var mult: float = speed_mult(uid)
	return {
		"percent": pct, "state": tag, "mult": mult, "penalty_pct": int(round((1.0 - mult) * 100.0))
	}
