class_name OrdersRouter
extends Node
## Routes validated orders from OrdersParser to units via adapters.
## Supports: MOVE, HOLD, CANCEL, ATTACK, DEFEND, RECON, FIRE, REPORT.

## Emitted when an order is applied to a unit.
signal order_applied(order: Dictionary)
## Emitted when an order cannot be applied.
signal order_failed(order: Dictionary, reason: String)

## Movement/LOS/Combat bridges
@export var movement_adapter: MovementAdapter ## Movement adapter node path
@export var los_adapter: LOSAdapter ## LOS adapter node path
@export var combat_controller: CombatController ## Combat controller path
@export var terrain_renderer: TerrainRender ## Used for grid/metric conversions

var _units_by_id: Dictionary
var _units_by_callsign: Dictionary

## Map OrdersParser.OrderType enum indices to names.
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

## Provide unit indices used to resolve targets.
func bind_units(id_index: Dictionary, callsign_index: Dictionary) -> void:
	_units_by_id = id_index
	_units_by_callsign = callsign_index

## Apply a single validated [param order]. Returns true if applied.
func apply(order: Dictionary) -> bool:
	var t := _normalize_type(order.get("type", "UNKNOWN"))
	var uid := str(order.get("unit_id", ""))
	var unit: ScenarioUnit = _units_by_id.get(uid)
	if unit == null:
		emit_signal("order_failed", order, "unknown_unit")
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

## MOVE: compute destination from grid id, target_callsign, or direction+quantity.
func _apply_move(unit: ScenarioUnit, order: Dictionary) -> bool:
	var dest: Variant = _compute_destination(unit, order)
	if dest == null:
		emit_signal("order_failed", order, "move_missing_destination")
		return false
	if movement_adapter and movement_adapter.plan_move(unit, dest):
		emit_signal("order_applied", order)
		return true
	emit_signal("order_failed", order, "move_plan_failed")
	return false

## HOLD/CANCEL: stop movement and clear combat intent if exposed by combat controller.
func _apply_hold(unit: ScenarioUnit, order: Dictionary) -> bool:
	if movement_adapter:
		movement_adapter.cancel_move(unit)
	if combat_controller and combat_controller.has_method("clear_intent"):
		combat_controller.clear_intent(unit)
	emit_signal("order_applied", order)
	return true

## ATTACK: prefer target_callsign; otherwise move by direction/quantity.
func _apply_attack(unit: ScenarioUnit, order: Dictionary) -> bool:
	if combat_controller and combat_controller.has_method("set_engagement_intent"):
		combat_controller.set_engagement_intent(unit, "attack")
	var dest: Variant = _compute_destination(unit, order, true)
	if dest != null and movement_adapter and movement_adapter.plan_move(unit, dest):
		emit_signal("order_applied", order)
		return true
	emit_signal("order_applied", order)
	return true

## DEFEND: move to a point if provided, else hold in place; flag posture if available.
func _apply_defend(unit: ScenarioUnit, order: Dictionary) -> bool:
	if combat_controller and combat_controller.has_method("set_posture"):
		combat_controller.set_posture(unit, "defend")
	var dest: Variant = _compute_destination(unit, order)
	if dest != null and movement_adapter and movement_adapter.plan_move(unit, dest):
		emit_signal("order_applied", order)
		return true
	return _apply_hold(unit, order)

## RECON: move with recon posture if supported.
func _apply_recon(unit: ScenarioUnit, order: Dictionary) -> bool:
	if combat_controller and combat_controller.has_method("set_posture"):
		combat_controller.set_posture(unit, "recon")
	var dest: Variant = _compute_destination(unit, order)
	if dest != null and movement_adapter and movement_adapter.plan_move(unit, dest):
		emit_signal("order_applied", order)
		return true
	emit_signal("order_failed", order, "recon_no_destination")
	return false

## FIRE: request an immediate/direct fire task if combat controller supports it.
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
	if movement_adapter and movement_adapter.plan_move(unit, target.position_m):
		emit_signal("order_applied", order)
		return true
	emit_signal("order_failed", order, "fire_unhandled")
	return false

## REPORT: informational; let SimWorld/RadioFeedback surface the message.
func _apply_report(_unit: ScenarioUnit, order: Dictionary) -> bool:
	emit_signal("order_applied", order)
	return true

## Compute destination from order fields. If [param prefer_target] is true, favor target_callsign.
func _compute_destination(unit: ScenarioUnit, order: Dictionary, prefer_target: bool = false) -> Variant:
	if prefer_target and order.has("target_callsign"):
		var tgt := _resolve_target(order)
		if tgt != null:
			return tgt.position_m
	if str(order.get("zone", "")).to_lower() == "grid" and order.has("quantity"):
		if terrain_renderer and terrain_renderer.has_method("grid_to_pos"):
			return terrain_renderer.grid_to_pos(str(order.get("quantity", 000000)))
	if order.has("target_callsign"):
		var tgt2 := _resolve_target(order)
		if tgt2 != null:
			return tgt2.position_m
	var dir := str(order.get("direction", ""))
	var qty := int(order.get("quantity", 0))
	if dir != "" and qty > 0:
		var dir_v := _dir_to_vec(dir)
		if dir_v.length() > 0.0:
			var dist_m := _quantity_to_meters(qty, str(order.get("zone", "")))
			return unit.position_m + dir_v.normalized() * dist_m
	return null

## Resolve unit target from callsign.
func _resolve_target(order: Dictionary) -> ScenarioUnit:
	var cs := str(order.get("target_callsign", ""))
	if cs == "":
		return null
	var other_uid: String = _units_by_callsign.get(cs, "")
	return _units_by_id.get(other_uid)

## Normalize order type to string token.
func _normalize_type(t: Variant) -> String:
	match typeof(t):
		TYPE_INT:
			return _TYPE_NAMES.get(int(t), "UNKNOWN")
		TYPE_STRING:
			return str(t).to_upper()
		_:
			return "UNKNOWN"

## Convert direction label to a 2D vector (meters coordinate space).
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

## Convert quantity + zone to meters.
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
