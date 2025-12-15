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
## Emitted when a CUSTOM order is received (for mission-specific handling).
## [br]Order dictionary contains: [code]custom_keyword[/code], [code]custom_full_text[/code],
## [code]custom_metadata[/code].
## [br]Connect to this signal to handle mission-specific voice commands that route as orders.
signal custom_order_received(order: Dictionary)

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
	8: "ENGINEER",
	9: "CUSTOM",
	10: "RETREAT",
	11: "UNKNOWN"
}

## Movement adapter used to plan and start moves.
@export var movement_adapter: MovementAdapter
## LOS adapter used for visibility-related routing.
@export var los_adapter: LOSAdapter
## Combat controller used to set intent/targets and fire missions.
@export var combat_controller: CombatController
## Artillery controller used for indirect fire missions.
@export var artillery_controller: ArtilleryController
## Engineer controller used for engineer tasks (mines, demo, bridges).
@export var engineer_controller: EngineerController
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
		"ENGINEER":
			return _apply_engineer(unit, order)
		"RETREAT":
			return _apply_retreat(unit, order)
		"CUSTOM":
			return _apply_custom(unit, order)
		_:
			emit_signal("order_failed", order, "unsupported_type")
			return false


## MOVE: compute destination from grid, target_callsign (unit or label), or direction+quantity.
## [param unit] Subject unit.
## [param order] Order dictionary.
## [return] `true` if movement was planned/started, else `false`.
func _apply_move(unit: ScenarioUnit, order: Dictionary) -> bool:
	_apply_navigation_bias(unit, order)
	var dest: Variant = _compute_destination(unit, order)
	if dest == null:
		emit_signal("order_failed", order, "move_missing_destination")
		return false
	if dest == Vector2.ZERO:
		emit_signal("order_failed", order, "move_destination_zero")
		return false

	# Check if this is a direct move (straight line, no pathfinding)
	var is_direct: bool = order.get("direct", false)
	var success: bool = false

	if movement_adapter:
		if is_direct:
			success = movement_adapter.plan_and_start_direct(unit, dest)
		else:
			success = movement_adapter.plan_and_start(unit, dest)
		if order.has("navigation_bias") and order.navigation_bias == StringName("roads"):
			LogService.info("Order applied with road bias for %s" % unit.id, "OrdersRouter.gd")

	if success:
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
	_apply_navigation_bias(unit, order)
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
	_apply_navigation_bias(unit, order)
	if combat_controller and combat_controller.has_method("set_posture"):
		combat_controller.set_posture(unit, "recon")
	var dest: Variant = _compute_destination(unit, order)
	if dest != null and movement_adapter and movement_adapter.plan_and_start(unit, dest):
		emit_signal("order_applied", order)
		return true
	emit_signal("order_failed", order, "recon_no_destination")
	return false


## FIRE: artillery indirect fire only (no direct fire or movement fallback).
## [param unit] Subject unit.
## [param order] Order dictionary.
## [return] `true` if applied, otherwise `false`.
func _apply_fire(unit: ScenarioUnit, order: Dictionary) -> bool:
	# FIRE order only works for artillery-capable units
	if not artillery_controller:
		LogService.error(
			"Artillery controller is NULL! Cannot process FIRE orders.", "OrdersRouter.gd"
		)
		emit_signal("order_failed", order, "fire_not_artillery")
		return false

	if not artillery_controller.is_artillery_unit(unit.id):
		emit_signal("order_failed", order, "fire_not_artillery")
		return false

	# Get destination from order (same as move orders)
	var dest: Variant = _compute_destination(unit, order)
	if dest == null or dest == Vector2.ZERO:
		emit_signal("order_failed", order, "fire_missing_target")
		return false

	# Get ammo type and rounds from order
	var ammo_type: String = order.get("ammo_type", "ap")
	var rounds: int = order.get("rounds", 1)

	# Map generic ammo type to unit-specific ammo type
	var available_types := artillery_controller.get_available_ammo_types(unit.id)
	var full_ammo_type := ""

	# Try to match ammo type to available types
	for available in available_types:
		if ammo_type == "ap" and available.ends_with("_AP"):
			full_ammo_type = available
			break
		elif ammo_type == "smoke" and available.ends_with("_SMOKE"):
			full_ammo_type = available
			break
		elif ammo_type == "illum" and available.ends_with("_ILLUM"):
			full_ammo_type = available
			break

	# If no matching ammo type found, try to use first available AP type
	if full_ammo_type == "":
		for available in available_types:
			if available.ends_with("_AP"):
				full_ammo_type = available
				break

	# If still no ammo type, fail the order
	if full_ammo_type == "":
		emit_signal("order_failed", order, "fire_no_ammo")
		return false

	# Request fire mission
	if artillery_controller.request_fire_mission(unit.id, dest, full_ammo_type, rounds):
		emit_signal("order_applied", order)
		return true
	else:
		emit_signal("order_failed", order, "fire_mission_rejected")
		return false


## REPORT: informational pass-through.
## [param _unit] Subject unit (unused).
## [param order] Order dictionary.
## [return] Always `true`.
func _apply_report(_unit: ScenarioUnit, order: Dictionary) -> bool:
	emit_signal("order_applied", order)
	return true


## ENGINEER: engineer task orders (mines, demo, bridges).
## [param unit] Subject unit.
## [param order] Order dictionary.
## [return] `true` if applied, otherwise `false`.
func _apply_engineer(unit: ScenarioUnit, order: Dictionary) -> bool:
	# ENGINEER order only works for engineer-capable units
	if not engineer_controller:
		LogService.error(
			"Engineer controller is NULL! Cannot process ENGINEER orders.", "OrdersRouter.gd"
		)
		emit_signal("order_failed", order, "engineer_controller_missing")
		return false

	if not engineer_controller.is_engineer_unit(unit.id):
		emit_signal("order_failed", order, "engineer_not_capable")
		return false

	# Get destination from order (same as move orders)
	var dest: Variant = _compute_destination(unit, order)
	if dest == null or dest == Vector2.ZERO:
		emit_signal("order_failed", order, "engineer_missing_target")
		return false

	# Get engineer task type from order
	var task_type: String = order.get("engineer_task", "mine")

	# Request engineer task (this queues the task, which will start when unit arrives)
	if not engineer_controller.request_task(unit.id, task_type, dest):
		emit_signal("order_failed", order, "engineer_task_rejected")
		return false

	# Move unit to destination (task will start when unit arrives)
	if movement_adapter and movement_adapter.plan_and_start(unit, dest):
		emit_signal("order_applied", order)
		return true

	# Movement failed, but task was queued (unit may already be at destination)
	emit_signal("order_applied", order)
	return true


## RETREAT: Unit falls back away from enemies silently (no player notifications).
## Calculates weighted retreat direction based on all nearby threats.
## If no threats are visible, retreats toward rear (south/southwest by default).
## [param unit] Subject unit.
## [param order] Order dictionary.
## [return] `true` if retreat was initiated, otherwise `false`.
func _apply_retreat(unit: ScenarioUnit, order: Dictionary) -> bool:
	if not movement_adapter:
		emit_signal("order_failed", order, "movement_adapter_missing")
		return false

	# Find all enemy units within extended threat range
	var threat_range_m := 5000.0  # Consider enemies within 5km (extended for better detection)
	var retreat_distance_m := 500.0  # Retreat at least 500m

	var threats: Array[ScenarioUnit] = []
	var enemy_affiliation := (
		ScenarioUnit.Affiliation.ENEMY
		if unit.affiliation == ScenarioUnit.Affiliation.FRIEND
		else ScenarioUnit.Affiliation.FRIEND
	)

	for uid in _units_by_id.keys():
		var other: ScenarioUnit = _units_by_id[uid]
		if other == null or other == unit or other.is_dead():
			continue
		if other.affiliation != enemy_affiliation:
			continue

		var dist := unit.position_m.distance_to(other.position_m)
		if dist <= threat_range_m:
			threats.append(other)

	var retreat_vec := Vector2.ZERO

	if threats.is_empty():
		# No visible threats - use default retreat direction (toward rear/south)
		# This allows retreat orders even when enemies aren't in LOS
		retreat_vec = Vector2(0, 1)  # South (assuming north is forward)
		LogService.info(
			"%s retreating to default direction (no threats detected)" % unit.callsign,
			"OrdersRouter"
		)
	else:
		# Calculate weighted retreat vector away from all threats
		for threat in threats:
			var to_threat := threat.position_m - unit.position_m
			var dist := to_threat.length()
			if dist < 1.0:
				dist = 1.0
			# Weight by inverse distance (closer threats are more important)
			var weight := 1.0 / (dist * dist)
			retreat_vec -= to_threat.normalized() * weight

		if retreat_vec.length_squared() < 0.01:
			# Fallback to default direction if calculation fails
			retreat_vec = Vector2(0, 1)
			LogService.warning(
				"%s retreat vector too small, using fallback" % unit.callsign, "OrdersRouter"
			)

	# Calculate retreat destination
	var retreat_dir := retreat_vec.normalized()
	var retreat_dest := unit.position_m + retreat_dir * retreat_distance_m

	# Plan and start retreat (silently, no radio messages)
	if movement_adapter.plan_and_start(unit, retreat_dest):
		LogService.info(
			"%s retreating from %d threats to %s" % [unit.callsign, threats.size(), retreat_dest],
			"OrdersRouter"
		)
		emit_signal("order_applied", order)
		return true

	emit_signal("order_failed", order, "retreat_movement_failed")
	return false


## CUSTOM: Emit signal for mission-specific handling. Does not apply standard routing.
## Emits [signal custom_order_received] with full order dictionary for external handling.
## [br][br]
## [b]Order dictionary contains:[/b]
## [br]- [code]custom_keyword: String[/code]
## [br]- [code]custom_full_text: String[/code]
## [br]- [code]custom_metadata: Dictionary[/code]
## [br]- [code]raw: PackedStringArray[/code]
## [param _unit] Subject unit (unused, but kept for consistency).
## [param order] Custom order dictionary with custom_keyword and custom_metadata.
## [return] Always returns [code]true[/code] (order is "accepted" but deferred to signal handlers).
func _apply_custom(_unit: ScenarioUnit, order: Dictionary) -> bool:
	emit_signal("custom_order_received", order)
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


## Apply navigation bias metadata to movement adapter if present.
func _apply_navigation_bias(unit: ScenarioUnit, order: Dictionary) -> void:
	if unit == null or order == null:
		return
	if not order.has("navigation_bias"):
		return
	if movement_adapter and movement_adapter.has_method("set_navigation_bias"):
		movement_adapter.set_navigation_bias(unit, order.navigation_bias)
