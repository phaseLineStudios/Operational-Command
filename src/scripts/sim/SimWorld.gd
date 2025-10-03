extends Node
## Authoritative battlefield simulation (state, movement, combat, LOS).
##
## Holds all unit entities and resolves ticks deterministically. Integrates
## visibility ([code]LOS.gd[/code]) and combat ([code]Combat.gd[/code]) and
## exposes read-only views for UI.

@onready var _ammo: AmmoSystem = AmmoSystem.new()

func _ready() -> void:
	add_child(_ammo)
	_ammo.ammo_profile = preload("res://data/ammo/default_caps.tres")

	# register units once roster is ready
	# leave commented out for now
	# for u in _current_units:
	#     _ammo.register_unit(u)

	# optional radio hookup
	var radio := get_tree().get_first_node_in_group("RadioFeedback") as RadioFeedback
	if radio:
		radio.bind_ammo(_ammo)

func _physics_process(delta: float) -> void:
	_ammo.tick(delta)

# call this from movement code whenever a unit moves
func on_unit_position(uid: String, pos: Vector3) -> void:
	_ammo.set_unit_position(uid, pos)
