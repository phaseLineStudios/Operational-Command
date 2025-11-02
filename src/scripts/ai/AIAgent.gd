extends Node
class_name AIAgent

signal behaviour_changed(unit_id: int, behaviour: int)
signal combat_mode_changed(unit_id: int, mode: int)

enum Behaviour { CARELESS, SAFE, AWARE, COMBAT, STEALTH }
enum ROE { HOLD_FIRE, RETURN_FIRE, OPEN_FIRE }

func _ready() -> void:
	pass

func set_behaviour(b: int) -> void:
	pass

func set_combat_mode(m: int) -> void:
	pass

func _apply_behaviour_mapping() -> void:
	pass

func intent_move_begin(point: Vector3) -> void:
	pass

func intent_move_check() -> bool:
	pass

func intent_defend_begin(center: Vector3, radius: float) -> void:
	pass

func intent_defend_check() -> bool:
	pass

func intent_patrol_begin(points: Array[Vector3], ping_pong: bool) -> void:
	pass

func intent_patrol_check() -> bool:
	pass

func intent_wait_begin(seconds: float, until_contact: bool) -> void:
	pass

func intent_wait_check(dt: float) -> bool:
	pass
