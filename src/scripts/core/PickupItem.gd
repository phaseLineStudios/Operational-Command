# This is script can be attached to a node to make it available for "pickup"
# If a node needs other scripts, create a subnode to the item you want to pickup for that
extends Node3D  # using Node3D as the pickup root

@export var item_name: String = "Generic Item"
var is_held: bool = false

# remember where the item came from (optional)
var _prev_parent: Node = null
var _prev_index: int = -1
var _prev_global: Transform3D

# if there is a StaticBody3D under this item, temporarily disable its collisions while held
@onready var _static_body: StaticBody3D = get_node_or_null("StaticBody3D")
var _saved_layer := 0
var _saved_mask := 0

func pickup(player: Node):
	if is_held:
		return
	is_held = true

	# Reparent this object to the player's HoldPoint
	var hold_point: Node3D = player.get_node("Camera3D/HoldPoint")

	# remember original parent, child index and global transform before moving it
	_prev_parent = get_parent()
	_prev_index = get_index()
	_prev_global = global_transform

	# disable the world's collisions for this item while held
	if _static_body:
		_saved_layer = _static_body.collision_layer
		_saved_mask = _static_body.collision_mask
		_static_body.collision_layer = 0
		_static_body.collision_mask = 0

	# reparent while keeping global first, then set local to exactly match HoldPoint
	reparent(hold_point, true)       # keep_global_transform = true
	transform = Transform3D.IDENTITY # lock to HoldPoint origin
	# translate_object_local(Vector3(0, 0, -0.5)) # optional offset
	rotation_degrees = Vector3.ZERO

	print("[PICKUP] Now held. parent=", get_parent().get_path())

func drop(player: Node):
	if not is_held:
		return

	# Choose where to return the item. Prefer the original parent if it is still valid.
	var world: Node = get_tree().current_scene
	var target_parent: Node = _prev_parent
	if target_parent == null or not is_instance_valid(target_parent):
		target_parent = world

	var before := get_parent()
	# Reparent back and keep current global so there is no jump during the move
	reparent(target_parent, true)

	# Restore the exact transform from before pickup so it snaps back to its place
	global_transform = _prev_global

	print("[PICKUP] Dropped. old_parent=", before.get_path(), " new_parent=", get_parent().get_path())

	# Re-enable collisions in the world
	if _static_body:
		_static_body.collision_layer = _saved_layer
		_static_body.collision_mask = _saved_mask

	is_held = false
