extends Node
class_name AIAgent

## Translates tasks into intents for your existing adapters in scripts/sim/adapters.

signal behaviour_changed(unit_id: int, behaviour: int)
signal combat_mode_changed(unit_id: int, mode: int)

enum Behaviour { CARELESS, SAFE, AWARE, COMBAT, STEALTH }
enum ROE { HOLD_FIRE, RETURN_FIRE, OPEN_FIRE }

@export var unit_id: int = -1
@export var movement_adapter_path: NodePath
@export var combat_adapter_path: NodePath
@export var los_adapter_path: NodePath
@export var orders_router_path: NodePath

var behaviour: int = Behaviour.SAFE
var combat_mode: int = ROE.RETURN_FIRE

var _movement                     ## your MovementAdapter instance
var _combat                       ## your CombatAdapter instance
var _los                          ## your LOSAdapter or LOS instance

var _wait_timer: float = 0.0
var _wait_until_contact: bool = false

var _router: OrdersRouter

func _ready() -> void:
	if orders_router_path.is_empty():
		_router = null
	else:
		_router = get_node_or_null(orders_router_path)
	
	if movement_adapter_path.is_empty(): _movement = null
	else: _movement = get_node_or_null(movement_adapter_path)
	if combat_adapter_path.is_empty(): _combat = null
	else: _combat = get_node_or_null(combat_adapter_path)
	if los_adapter_path.is_empty(): _los = null
	else: _los = get_node_or_null(los_adapter_path)
	
	_apply_behaviour_mapping()
	if _combat != null:
		_combat.set_rules_of_engagement(combat_mode)

## External notification that a hostile shot was observed against this unit.
func notify_hostile_shot() -> void:
	if _combat != null and _combat.has_method("report_hostile_shot_observed"):
		_combat.report_hostile_shot_observed()

func _get_su() -> ScenarioUnit:
	if Game.current_scenario == null:
		return null
	var units := Game.current_scenario.units
	if unit_id >= 0 and unit_id < units.size():
		return units[unit_id]
	return null

func set_behaviour(b: int) -> void:
	behaviour = b
	emit_signal("behaviour_changed", unit_id, behaviour)
	_apply_behaviour_mapping()

func set_combat_mode(m: int) -> void:
	combat_mode = m
	emit_signal("combat_mode_changed", unit_id, combat_mode)
	if _combat != null:
		_combat.set_rules_of_engagement(combat_mode)

func _apply_behaviour_mapping() -> void:
	var speed_mult: float = 1.0
	var cover_bias: float = 0.5
	var noise_level: float = 0.6

	match behaviour:
		Behaviour.CARELESS:
			speed_mult = 1.25
			cover_bias = 0.2
			noise_level = 1.0
		Behaviour.SAFE:
			speed_mult = 1.0
			cover_bias = 0.5
			noise_level = 0.6
		Behaviour.AWARE:
			speed_mult = 0.85
			cover_bias = 0.8
			noise_level = 0.4
		Behaviour.COMBAT:
			speed_mult = 0.75
			cover_bias = 0.9
			noise_level = 0.5
		Behaviour.STEALTH:
			speed_mult = 0.6
			cover_bias = 1.0
			noise_level = 0.2

	if _movement != null and _movement.has_method("set_behaviour_params"):
		_movement.set_behaviour_params(speed_mult, cover_bias, noise_level)
	# Also pass speed multiplier to the ScenarioUnit for pathing speed
	var su := _get_su()
	if su:
		su.set_meta("behaviour_speed_mult", speed_mult)

## Begin a move intent using ScenarioUnit + MovementAdapter pathing
func intent_move_begin(point_m: Variant) -> void:
	var su := _get_su()
	if su == null or _movement == null:
		return
	var dest_m: Vector2 = Vector2.ZERO
	match typeof(point_m):
		TYPE_VECTOR2:
			dest_m = point_m
		TYPE_VECTOR3:
			var v3: Vector3 = point_m
			dest_m = Vector2(v3.x, v3.z)
		_:
			return
	if _movement.has_method("plan_and_start"):
		_movement.plan_and_start(su, dest_m)

func intent_move_check() -> bool:
	var su := _get_su()
	if su == null:
		return true
	return su.move_state() == ScenarioUnit.MoveState.ARRIVED

func intent_defend_begin(center_m: Variant, _radius: float) -> void:
	var su := _get_su()
	if su == null or _movement == null:
		return
	var dest_m: Vector2 = Vector2.ZERO
	if typeof(center_m) == TYPE_VECTOR2:
		dest_m = center_m as Vector2
	else:
		var c3: Vector3 = center_m
		dest_m = Vector2(c3.x, c3.z)
	if _movement.has_method("plan_and_start"):
		_movement.plan_and_start(su, dest_m)

func intent_defend_check() -> bool:
	var su := _get_su()
	if su == null:
		return true
	# Consider defend established when unit is idle (arrived or holding)
	return su.move_state() in [ScenarioUnit.MoveState.ARRIVED, ScenarioUnit.MoveState.IDLE]

func intent_patrol_begin(points: Array[Vector3], ping_pong: bool) -> void:
	# Minimal fallback: treat first point as a move, then complete
	if points.size() > 0:
		intent_move_begin(points[0])

func intent_patrol_check() -> bool:
	return intent_move_check()

func intent_wait_begin(seconds: float, until_contact: bool) -> void:
	_wait_timer = max(seconds, 0.0)
	_wait_until_contact = until_contact

func intent_wait_check(dt: float) -> bool:
	if _wait_until_contact:
		if _los != null and _los.has_hostile_contact():
			_wait_timer = 0.0
			return true
		# Fallback to SimWorld contacts
		var su := _get_su()
		var sim := get_tree().get_root().find_child("SimWorld", true, false)
		if su and sim and sim.has_method("get_contacts_for_unit"):
			var contacts: Array = sim.get_contacts_for_unit(su.id)
			if contacts.size() > 0:
				_wait_timer = 0.0
				return true
	_wait_timer = max(_wait_timer - dt, 0.0)
	return _wait_timer <= 0.0
