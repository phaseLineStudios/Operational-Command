extends Node
class_name CombatAdapter
## Fire gating and ammo consumption before Combat.gd applies effects.

signal fire_blocked_empty(unit_id: String, ammo_type: String)

@export var ammo_system_path: NodePath
var _ammo: AmmoSystem

func _ready() -> void:
	if ammo_system_path != NodePath(""):
		_ammo = get_node(ammo_system_path) as AmmoSystem

func request_fire(unit_id: String, ammo_type: String, rounds: int = 1) -> bool:
	if _ammo == null:
		return true
	var u := _ammo.get_unit(unit_id)
	if u == null:
		return true
	if not u.state_ammunition.has(ammo_type):
		return true
	if _ammo.is_empty(u, ammo_type):
		emit_signal("fire_blocked_empty", unit_id, ammo_type)
		return false
	return _ammo.consume(unit_id, ammo_type, max(1, rounds))
