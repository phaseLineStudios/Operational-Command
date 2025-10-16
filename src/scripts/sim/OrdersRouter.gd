class_name OrdersRouter
extends Node
## Orders router for validated commands.
##
## Routes parsed orders to movement/LOS/combat adapters and utilities.
## Supports MOVE, HOLD, CANCEL, ATTACK, DEFEND, RECON, FIRE, REPORT.
## @experimental

## Emitted when an order is applied to a unit.
signal order_applied(order: Dictionary)
## Emitted when an order cannot be applied.
signal order_failed(order: Dictionary, reason: String)

## Map OrdersParser.OrderType enum indices to string tokens.
const _TYPE_NAMES := {
	0: "MOVE",
	1: "HOLD",
	2: "ATTACK",
	3: "DEFEND",
	4: "RECON",
	5: "FIRE",
	6: "REPORT",
	7: "CANCEL",
	8: "UNKNOWN"
}

## Movement adapter used to plan and start moves.
@export var movement_adapter: MovementAdapter
## LOS adapter used for visibility-related routing.
@export var los_adapter: LOSAdapter
## Combat controller used to set intent/targets and fire missions.
@export var combat_controller: CombatController
## Terrain renderer for grid/metric conversions.
@export var terrain_renderer: TerrainRender

var _units_by_id: Dictionary
var _units_by_callsign: Dictionary


## Supply unit indices used by this router.
## [param id_index] Dictionary String->ScenarioUnit (by unit id).
## [param callsign_index] Dictionary String->unit_id (by callsign).
func bind_units(id_index: Dictionary, callsign_index: Dictionary) -> void:
	_units_by_id = id_index
	_units_by_callsign = callsign_index


## Apply a single validated order.
## [param order] Normalized order dictionary from OrdersParser.
## [return] `true` if applied, otherwise `false`.
func apply(order: Dictionary) -> bool:
	var t := _normalize_type(order.get("type", "UNKNOWN"))
	var uid := str(order.get("unit_id", ""))
	var unit: ScenarioUnit = _units_by_id.get(uid)
	if unit == null:
		emit_signal("order_failed", order, "unknown_unit")
		return false
	
	if unit.is_dead():
		emit_signal("order_failed", order, "dead_unit")
		return false

	match t:
		"MOVE":
			return _apply_move(unit, order)
		"HOLD", "CANCEL":
			return _apply_hold(unit, order)
		"ATTACK":
			return _apply_attack(unit, order)
		"DEFEND":
			return _apply_defend(unit, order)
		"RECON":
			return _apply_recon(unit, order)
		"FIRE":
			return _apply_fire(unit, order)
		"REPORT":
			return _apply_report(unit, order)
		_:
			emit_signal("order_failed", order, "unsupported_type")
			return false


## MOVE: compute destination from grid, target_callsign (unit or label), or direction+quantity.
## [param unit] Subject unit.
## [param order] Order dictionary.
## [return] `true` if movement was planned/started, else `false`.
func _apply_move(unit: ScenarioUnit, order: Dictionary) -> bool:
	var dest: Variant = _compute_destination(unit, order)
	if dest == null:
		emit_signal("order_failed", order, "move_missing_destination")
		return false
	if dest == Vector2.ZERO:
		emit_signal("order_failed", order, "move_destination_zero")
		return false
	if movement_adapter and movement_adapter.plan_and_start(unit, dest):
		emit_signal("order_applied", order)
		return true
	emit_signal("order_failed", order, "move_plan_failed")
	return false


## HOLD/CANCEL: stop movement and clear combat intent (if supported).
## [param unit] Subject unit.
## [param order] Order dictionary.
## [return] Always `true`.
func _apply_hold(unit: ScenarioUnit, order: Dictionary) -> bool:
	if movement_adapter:
		movement_adapter.cancel_move(unit)
	if combat_controller and combat_controller.has_method("clear_intent"):
		combat_controller.clear_intent(unit)
	emit_signal("order_applied", order)
	return true


## ATTACK: prefer target_callsign; otherwise use movement fallback.
## [param unit] Subject unit.
## [param order] Order dictionary.
## [return] Always `true` (intent set even if no move).
func _apply_attack(unit: ScenarioUnit, order: Dictionary) -> bool:
	if combat_controller and combat_controller.has_method("set_engagement_intent"):
		combat_controller.set_engagement_intent(unit, "attack")
	var dest: Variant = _compute_destination(unit, order, true)
	if dest != null and movement_adapter and movement_adapter.plan_and_start(unit, dest):
		emit_signal("order_applied", order)
		return true
	emit_signal("order_applied", order)
	return true


## DEFEND: move to destination if present; otherwise hold.
## [param unit] Subject unit.
## [param order] Order dictionary.
## [return] `true` if applied.
func _apply_defend(unit: ScenarioUnit, order: Dictionary) -> bool:
	if combat_controller and combat_controller.has_method("set_posture"):
		combat_controller.set_posture(unit, "defend")
	var dest: Variant = _compute_destination(unit, order)
	if dest != null and movement_adapter and movement_adapter.plan_and_start(unit, dest):
		emit_signal("order_applied", order)
		return true
	return _apply_hold(unit, order)


## RECON: move with recon posture if supported.
## [param unit] Subject unit.
## [param order] Order dictionary.
## [return] `true` if applied, `false` if missing destination.
func _apply_recon(unit: ScenarioUnit, order: Dictionary) -> bool:
	if combat_controller and combat_controller.has_method("set_posture"):
		combat_controller.set_posture(unit, "recon")
	var dest: Variant = _compute_destination(unit, order)
	if dest != null and movement_adapter and movement_adapter.plan_and_start(unit, dest):
		emit_signal("order_applied", order)
		return true
	emit_signal("order_failed", order, "recon_no_destination")
	return false


## FIRE: request fire mission if possible; else move to target unit.
## [param unit] Subject unit.
## [param order] Order dictionary.
## [return] `true` if applied, otherwise `false`.
func _apply_fire(unit: ScenarioUnit, order: Dictionary) -> bool:
	var target: ScenarioUnit = _resolve_target(order)
	if target == null:
		if combat_controller and combat_controller.has_method("set_engagement_intent"):
			combat_controller.set_engagement_intent(unit, "fire")
			emit_signal("order_applied", order)
			return true
		emit_signal("order_failed", order, "fire_missing_target")
		return false
	if combat_controller:
		if combat_controller.has_method("request_fire_mission"):
			combat_controller.request_fire_mission(unit, target)
			emit_signal("order_applied", order)
			return true
		elif combat_controller.has_method("set_target"):
			combat_controller.set_target(unit, target)
			emit_signal("order_applied", order)
			return true
	if movement_adapter and movement_adapter.plan_and_start(unit, target.position_m):
		emit_signal("order_applied", order)
		return true
	emit_signal("order_failed", order, "fire_unhandled")
	return false


## REPORT: informational pass-through.
## [param _unit] Subject unit (unused).
## [param order] Order dictionary.
## [return] Always `true`.
func _apply_report(_unit: ScenarioUnit, order: Dictionary) -> bool:
	emit_signal("order_applied", order)
	return true


## Compute a concrete destination from an order.
## Priority: target unit (when [param prefer_target]) -> grid position
## -> label via target_callsign -> plain target_callsign unit -> direction+quantity.
## When a label is detected in `target_callsign`, returns a Vector2 position
## resolved through the movement adapter.
## [param unit] Subject unit (for direction-based movement).
## [param order] Order dictionary.
## [param prefer_target] If `true`, prefer unit target for ATTACK.
## [return] Vector2 destination or `null` if none.
func _compute_destination(
	unit: ScenarioUnit, order: Dictionary, prefer_target: bool = false
) -> Variant:
	if prefer_target and order.has("target_callsign"):
		var s := str(order.get("target_callsign", "")).strip_edges()
		var tgt := _resolve_target(order)
		if tgt != null:
			return tgt.position_m
		if s != "" and _is_label_name(s):
			print(movement_adapter._resolve_label_to_pos(_norm_label(s)))
			return movement_adapter._resolve_label_to_pos(_norm_label(s))

	if str(order.get("zone", "")).to_lower() == "grid" and order.has("quantity"):
		if terrain_renderer:
			return terrain_renderer.grid_to_pos(str(order.get("quantity", 000000)))

	if order.has("target_callsign"):
		var s3 := str(order.get("target_callsign", "")).strip_edges()
		var tgt2 := _resolve_target(order)
		if tgt2 != null:
			return tgt2.position_m
		if s3 != "" and _is_label_name(s3):
			print(movement_adapter._resolve_label_to_pos(_norm_label(s3)))
			return movement_adapter._resolve_label_to_pos(_norm_label(s3))

	var dir := str(order.get("direction", ""))
	var qty := int(order.get("quantity", 0))
	if dir != "" and qty > 0:
		var dir_v := _dir_to_vec(dir)
		if dir_v.length() > 0.0:
			var dist_m := _quantity_to_meters(qty, str(order.get("zone", "")))
			return unit.position_m + dir_v.normalized() * dist_m
	return null


## Resolve a unit from `target_callsign`.
## [param order] Order dictionary.
## [return] ScenarioUnit or `null`.
func _resolve_target(order: Dictionary) -> ScenarioUnit:
	var cs := str(order.get("target_callsign", ""))
	if cs == "":
		return null
	var other_uid: String = _units_by_callsign.get(cs, "")
	return _units_by_id.get(other_uid)


## Test whether a string matches a TerrainData label (tolerant).
## [param l_name] Candidate label text.
## [return] `true` if a matching label exists.
func _is_label_name(l_name: String) -> bool:
	if terrain_renderer == null or terrain_renderer.data == null:
		return false
	var key := _norm_label(l_name)
	for label in terrain_renderer.data.labels:
		var txt := str(label.get("text", "")).strip_edges()
		if txt == "":
			continue
		if _norm_label(txt) == key:
			return true
	return false


## Normalize label text for matching (lowercase, strip punctuation, collapse spaces).
## [param s] Input text.
## [return] Normalized key string.
func _norm_label(s: String) -> String:
	var t := s.strip_edges().to_lower()
	for bad in [
		",",
		".",
		":",
		";",
		"(",
		")",
		"[",
		"]",
		"'",
		'"',
		"?",
		"!",
		"@",
		"#",
		"$",
		"%",
		"^",
		"&",
		"*",
		"+",
		"=",
		"|",
		"\\"
	]:
		t = t.replace(bad, "")
	t = t.replace("-", " ").replace("_", " ").replace("/", " ")
	while t.find("  ") != -1:
		t = t.replace("  ", " ")
	return t


## Normalize an order type to its string token.
## [param t] Enum index or string.
## [return] Uppercase type token.
func _normalize_type(t: Variant) -> String:
	match typeof(t):
		TYPE_INT:
			return _TYPE_NAMES.get(int(t), "UNKNOWN")
		TYPE_STRING:
			return str(t).to_upper()
		_:
			return "UNKNOWN"


## Convert a cardinal/intercardinal label to a unit vector (meters space).
## [param dir] Direction label (e.g. "NE", "southwest").
## [return] Vector2 direction (length may be 0 if unknown).
func _dir_to_vec(dir: String) -> Vector2:
	var d := dir.to_lower()
	match d:
		"n", "north":
			return Vector2(0, -1)
		"ne", "northeast":
			return Vector2(1, -1)
		"e", "east":
			return Vector2(1, 0)
		"se", "southeast":
			return Vector2(1, 1)
		"s", "south":
			return Vector2(0, 1)
		"sw", "southwest":
			return Vector2(-1, 1)
		"w", "west":
			return Vector2(-1, 0)
		"nw", "northwest":
			return Vector2(-1, -1)
		_:
			return Vector2.ZERO


## Convert a quantity and zone to meters.
## [param qty] Quantity value.
## [param zone] Unit label (e.g. "m", "km", "grid").
## [return] Distance in meters.
func _quantity_to_meters(qty: int, zone: String) -> float:
	var z := zone.to_lower()
	match z:
		"m", "meter", "meters":
			return float(qty)
		"km", "kilometer", "kilometers":
			return float(qty) * 1000.0
		"grid", "tile", "cell", "square":
			if terrain_renderer and terrain_renderer.has_method("cell_size_m"):
				return float(qty) * float(terrain_renderer.cell_size_m())
			return float(qty) * 50.0
		_:
			return float(qty)
