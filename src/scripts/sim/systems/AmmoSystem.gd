extends Node
class_name AmmoSystem

signal ammo_low(unit_id: String)
signal ammo_critical(unit_id: String)
signal ammo_empty(unit_id: String)
signal resupply_started(src_unit_id: String, dst_unit_id: String)
signal resupply_completed(src_unit_id: String, dst_unit_id: String)

@export var ammo_profile: AmmoProfile

var _units: Dictionary = {}          # unit_id -> UnitData
var _positions: Dictionary = {}      # unit_id -> Vector3
var _logi: Dictionary = {}           # unit_id -> bool
var _active_links: Dictionary = {}   # dst_id -> src_id
var _xfer_accum: Dictionary = {}     # dst_id -> float (carry fractional budget)

func _ready() -> void:
	add_to_group("AmmoSystem")

func _physics_process(delta: float) -> void:
	tick(delta)

func register_unit(u: UnitData) -> void:
	_units[u.id] = u
	if ammo_profile:
		ammo_profile.apply_defaults_if_missing(u)
	_logi[u.id] = _is_logistics(u)

func unregister_unit(unit_id: String) -> void:
	_units.erase(unit_id)
	_positions.erase(unit_id)
	_logi.erase(unit_id)
	for dst in _active_links.keys().duplicate():
		if _active_links[dst] == unit_id or dst == unit_id:
			_active_links.erase(dst)
	_xfer_accum.erase(unit_id)

func set_unit_position(unit_id: String, pos: Vector3) -> void:
	_positions[unit_id] = pos

func get_unit(unit_id: String) -> UnitData:
	return _units.get(unit_id, null)

func is_low(u: UnitData, t: String) -> bool:
	var cap := int(u.ammunition.get(t, 0))
	if cap <= 0: return false
	var cur := int(u.state_ammunition.get(t, 0))
	return cur > 0 and float(cur)/float(cap) <= u.ammunition_low_threshold

func is_critical(u: UnitData, t: String) -> bool:
	var cap := int(u.ammunition.get(t, 0))
	if cap <= 0: return false
	var cur := int(u.state_ammunition.get(t, 0))
	return cur > 0 and float(cur)/float(cap) <= u.ammunition_critical_threshold

func is_empty(u: UnitData, t: String) -> bool:
	return int(u.state_ammunition.get(t, 0)) <= 0

func consume(unit_id: String, t: String, amount: int = 1) -> bool:
	var u : UnitData= _units.get(unit_id, null)
	if u == null or not u.state_ammunition.has(t):
		return false
	var cur := int(u.state_ammunition[t])
	if cur <= 0:
		u.state_ammunition[t] = 0
		emit_signal("ammo_empty", unit_id)
		return false
	var newv : int = max(0, cur - max(1, amount))
	u.state_ammunition[t] = newv
	if newv <= 0:
		emit_signal("ammo_empty", unit_id)
	elif is_critical(u, t):
		emit_signal("ammo_critical", unit_id)
	elif is_low(u, t):
		emit_signal("ammo_low", unit_id)
	return true

func tick(delta: float) -> void:
	# start links for any needy unit
	for uid in _units.keys():
		if _active_links.has(uid):
			continue
		var dst : UnitData = _units[uid]
		if not _needs_ammo(dst):
			continue
		var src_id := _pick_link_for(dst)
		if src_id != "":
			_begin_link(src_id, uid)
	# transfer along active links
	_transfer_tick(delta)

func _within_radius(src: UnitData, dst: UnitData) -> bool:
	if not _positions.has(src.id) or not _positions.has(dst.id):
		return false
	var a: Vector3 = _positions[src.id]
	var b: Vector3 = _positions[dst.id]
	return a.distance_to(b) <= max(src.supply_transfer_radius_m, 0.0)

func _is_logistics(u: UnitData) -> bool:
	if u.throughput is Dictionary and not u.throughput.is_empty():
		return true
	if u.equipment_tags is Array and (
		u.equipment_tags.has("AMMO_PALLET") or
		u.equipment_tags.has("AMMUNITION_PALLET") or
		u.equipment_tags.has("LOGISTICS")):
		return true
	return false

func _needs_ammo(u: UnitData) -> bool:
	for t in u.ammunition.keys():
		if int(u.state_ammunition.get(t, 0)) < int(u.ammunition[t]):
			return true
	return false

func _has_stock(u: UnitData) -> bool:
	for t in u.throughput.keys():
		if int(u.throughput[t]) > 0:
			return true
	return false

func _pick_link_for(dst: UnitData) -> String:
	for sid in _units.keys():
		if sid == dst.id:
			continue
		if not _logi.get(sid, false):
			continue
		var src: UnitData = _units[sid]
		if not _has_stock(src):
			continue
		if not _within_radius(src, dst):
			continue
		return sid
	return ""

func _begin_link(src_id: String, dst_id: String) -> void:
	_active_links[dst_id] = src_id
	_xfer_accum[dst_id] = 0.0
	emit_signal("resupply_started", src_id, dst_id)

func _finish_link(dst_id: String) -> void:
	var src_id: String = _active_links.get(dst_id, "")
	if src_id != "":
		emit_signal("resupply_completed", src_id, dst_id)
	_active_links.erase(dst_id)
	_xfer_accum.erase(dst_id)

func _transfer_tick(delta: float) -> void:
	for dst_id in _active_links.keys().duplicate():
		var src: UnitData = _units.get(_active_links[dst_id], null)
		var dst: UnitData = _units.get(dst_id, null)
		if src == null or dst == null or not _within_radius(src, dst) or not _has_stock(src):
			_finish_link(dst_id)
			continue

		# accumulate fractional budget so low rates still transfer at 60 FPS
		var acc := float(_xfer_accum.get(dst_id, 0.0))
		acc += max(0.0, src.supply_transfer_rate) * delta
		var transferable := int(floor(acc))
		if transferable <= 0:
			_xfer_accum[dst_id] = acc
			continue

		var remaining := transferable
		var transferred := 0

		for t in dst.ammunition.keys():
			if remaining <= 0:
				break
			var cap := int(dst.ammunition[t])
			var cur := int(dst.state_ammunition.get(t, 0))
			if cur >= cap:
				continue
			var need := cap - cur
			var stock := int(src.throughput.get(t, 0))
			if stock <= 0:
				continue
			var xfer : int = min(need, stock, remaining)
			if xfer <= 0:
				continue

			dst.state_ammunition[t] = cur + xfer
			src.throughput[t] = stock - xfer
			remaining -= xfer
			transferred += xfer

		_xfer_accum[dst_id] = acc - float(transferred)

		if not _needs_ammo(dst) or not _has_stock(src):
			_finish_link(dst_id)
