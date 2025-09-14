# This script will hold all the stuff that is needed for item pickup
# In earlier versions, this was in the Player.gd script 
# Since there is no longer a player, everyhing was moved to this script

# TODO: Think about where to attach this
# Since we plan on making it also multi player (if we have time)
# we should not attach it to the main scene
# maybe a dedicated PlayerInteraction node

extends Node

# Store the HoldPoint in variable on load
@onready var hold_point: Node3D = $Camera3D/HoldPoint
@onready var cam: Camera3D = $Camera3D

# Set the held_item to null
# This is important because at the start nothing is held by the player
var held_item: Node = null
var viewing_item: Node = null

# Creating variables for the camera
# TODO: should we remove this variable?
# This is from the old version of the script, I just copied it to not have problems
# But probably not the best way of doing this now with the new CameraRig method
var camera

# Runs whenever the scene is loaded, after all nodes are loaded
func _ready():
	camera = $Camera3D
	
	
	# Handles all types of inputs, first input function that is executed
func _input(_event):
	# handling the interact events (usually E)
	if Input.is_action_just_pressed("interact"):
		if held_item:
			print("[PLAYER] Dropping: ", held_item.name)
			held_item.drop(self)
			held_item = null
		else:
			try_pickup_drag()


# function to handle pickups using drag and drop
func try_pickup_drag():
	# Handle pickup

	var nearest_item: Node = null
	var nearest_dist := INF
	# Use range(hit_count) because hit_count is an int, not an iterable.
	for i in range(hit_count):
		var collider := ray.get_collider(i)
		print("[DEBUG]   collider:", collider)
		var item := _find_pickup_item(collider)
		if item and item.has_method("pickup") and not held_item:
			var hit_pos := ray.get_collision_point(i)
			# Use plain assignment to avoid static typing inference on an unknown camera type.
			var dist = camera.global_position.distance_to(hit_pos)
			print("[DEBUG]   -> candidate %s at %.3f" % [item.name, dist])
			if dist < nearest_dist:
				nearest_dist = dist
				nearest_item = item

	if nearest_item:
		nearest_item.pickup(self)
		held_item = nearest_item
		print("[PLAYER] Picked up:", held_item.name)
	else:
		print("[DEBUG] Only non-pickable colliders were hit")

# function to handle drops using drag and drop
func drop_drap():
	pass
	
# placeholder to pickup items and view them infront of the camera
func try_view_item():
	pass

# placeholder to drop items viewed infront of the camera
func drop_view_item():
	pass

	
# function is used to find the item a player wants to pickup
func _find_pickup_item(obj: Object) -> Node:
	# Walk up the parent chain until we either find a node that implements `pickup()`
	# or we run out of parents.
	var n := obj
	while n is Node:
		if n.has_method("pickup"):
			return n
		n = n.get_parent()
	return null  # no pickable item found
	
# placeholder function to view item infront of the camera
func _position_item_in_front(item: Node):
	pass

# placeholder function to place items back when after viewing in front of camera
func _restore_item_position(item: Node):
	pass
