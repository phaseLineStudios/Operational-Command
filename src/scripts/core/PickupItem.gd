# This is script can be attached to a node to make it available for "pickup"
# If a node needs other scripts, create a subnode to the item you want to pickup for that
extends Area3D

@export var item_name: String = "Generic Item"
var is_held: bool = false

func pickup(player: Node):
	if is_held:
		return
	is_held = true

	# Reparent this object to the player's HoldPoint
	var hold_point = player.get_node("Camera3D/HoldPoint")
	get_parent().remove_child(self)
	hold_point.add_child(self)

	# Snap into position in front of the camera
	global_transform = hold_point.global_transform
	transform.origin = Vector3.ZERO
	rotation_degrees = Vector3.ZERO

func drop(player: Node):
	if not is_held:
		return
	var world = get_tree().current_scene
	var global_pos = global_transform

	# Remove from HoldPoint and put back into the world
	player.get_node("Camera3D/HoldPoint").remove_child(self)
	world.add_child(self)
	global_transform = global_pos
	is_held = false
