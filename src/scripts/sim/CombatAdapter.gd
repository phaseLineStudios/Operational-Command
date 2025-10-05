extends Node
class_name CombatAdapter
## Small adapter that gates firing on ammo and consumes on success.
## Keeps UI/Combat code cleaner and emits a signal when firing is blocked.

## Emitted when a unit attempts to fire but is out of the requested ammo type.
signal fire_blocked_empty(unit_id: String, ammo_type: String)

## NodePath to an AmmoSystem node in the scene.
@export var ammo_system_path: NodePath

var _ammo: AmmoSystem  ## Cached AmmoSystem reference

## Resolve the AmmoSystem reference when the node enters the tree.
func _ready() -> void:
	if ammo_system_path != NodePath(""):
		_ammo = get_node(ammo_system_path) as AmmoSystem
	add_to_group("CombatAdapter")

## Request to fire: returns true if ammo was consumed; false if blocked.
## Fails open (true) when there is no ammo system or unit is unknown.
func request_fire(unit_id: String, ammo_type: String, rounds: int = 1) -> bool:
	if _ammo == null:
		return true
	var u := _ammo.get_unit(unit_id)
	if u == null:
		return true

	# If the unit doesn't track this ammo type, allow it.
	if not u.state_ammunition.has(ammo_type):
		return true

	# Empty blocks firing.
	if _ammo.is_empty(u, ammo_type):
		emit_signal("fire_blocked_empty", unit_id, ammo_type)
		return false

	return _ammo.consume(unit_id, ammo_type, max(1, rounds))
