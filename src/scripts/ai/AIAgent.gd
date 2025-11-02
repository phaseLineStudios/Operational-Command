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

var behaviour: int = Behaviour.SAFE
var combat_mode: int = ROE.RETURN_FIRE

var _movement                     ## your MovementAdapter instance
var _combat                       ## your CombatAdapter instance
var _los                          ## your LOSAdapter or LOS instance

var _wait_timer: float = 0.0
var _wait_until_contact: bool = false

func _ready() -> void:
	if movement_adapter_path.is_empty(): _movement = null
	else: _movement = get_node_or_null(movement_adapter_path)
	if combat_adapter_path.is_empty(): _combat = null
	else: _combat = get_node_or_null(combat_adapter_path)
	if los_adapter_path.is_empty(): _los = null
	else: _los = get_node_or_null(los_adapter_path)
	
	_apply_behaviour_mapping()
	if _combat != null:
		_combat.set_rules_of_engagement(combat_mode)

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

	if _movement != null:
		_movement.set_behaviour_params(speed_mult, cover_bias, noise_level)

func intent_move_begin(point: Vector3) -> void:
	if _movement != null:
		_movement.request_move_to(point)

func intent_move_check() -> bool:
	if _movement == null:
		return true
	return bool(_movement.is_move_complete())

func intent_defend_begin(center: Vector3, radius: float) -> void:
	if _movement != null:
		_movement.request_hold_area(center, radius)

func intent_defend_check() -> bool:
	if _movement == null:
		return true
	return bool(_movement.is_hold_established())

func intent_patrol_begin(points: Array[Vector3], ping_pong: bool) -> void:
	if _movement != null:
		_movement.request_patrol(points, ping_pong)

func intent_patrol_check() -> bool:
	if _movement == null:
		return true
	return not bool(_movement.is_patrol_running())

func intent_wait_begin(seconds: float, until_contact: bool) -> void:
	_wait_timer = max(seconds, 0.0)
	_wait_until_contact = until_contact

func intent_wait_check(dt: float) -> bool:
	if _wait_until_contact and _los != null:
		if _los.has_hostile_contact():
			_wait_timer = 0.0
			return true
	_wait_timer = max(_wait_timer - dt, 0.0)
	return _wait_timer <= 0.0
