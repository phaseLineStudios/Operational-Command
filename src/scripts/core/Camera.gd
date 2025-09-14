# Script for the player behaviour in the 3d scenes (mainly for hq_table.tscn)

extends Node3D

# Store the RayCast and HoldPoint in variables on load
@onready var ray: ShapeCast3D = $Camera3D/ShapeCast3D
@onready var hold_point: Node3D = $Camera3D/HoldPoint

# Setting up the speed and mouse sensitivity
@export var speed := 1.5

# Creating variables for the camera
var camera

# Set the held_item to null
# This is important because at the start nothing is held by the player
var held_item: Node = null

# Runs whenever the scene is loaded, after all nodes are loaded
func _ready():
	camera = $Camera3D
	# Lock and hide the mouse, makes the game more immersive
	# IMPORTANT: UNCOMMENT THIS LINE IF THE MOUSE NEEDS TO BE CAPTURED
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	# Check if the shapecast is configured correctly:
	assert(ray != null, "ShapeCast3D not found at $Camera3D/ShapeCast3D")
	assert(ray.shape != null, "ShapeCast3D.shape is not set")
	ray.enabled = true

# Handles all types of inputs, first input function that is executed
func _input(_event):
	# handling the interact events (usually E)
	if Input.is_action_just_pressed("interact"):
		if held_item:
			print("[PLAYER] Dropping: ", held_item.name)
			held_item.drop(self)
			held_item = null
		else:
			try_pickup()

# called every physics frame (like 60Hz)
# ideal for movement, collisions and gravity
# since _process should not be used for player movement, use _physics_process for this
func _physics_process(delta):
	var direction = Vector3.ZERO

	# handling the inputs by the player
	if Input.is_action_pressed("move_forward"):
		direction -= transform.basis.z
	if Input.is_action_pressed("move_back"):
		direction += transform.basis.z
	if Input.is_action_pressed("move_left"):
		direction -= transform.basis.x
	if Input.is_action_pressed("move_right"):
		direction += transform.basis.x

# function to handle pickups
func try_pickup():
	if ray == null:
		push_error("ShapeCast3D is null; check the node path.")
		return

	ray.force_shapecast_update()
	var hit_count := ray.get_collision_count()
	if hit_count == 0:
		print("[DEBUG] No hits. enabled=%s mask=%d target=%s shape=%s" % [
			str(ray.enabled), ray.collision_mask, str(ray.target_position), str(ray.shape)
		])
		return

	var nearest_item: Node = null
	var nearest_dist := INF

	print("[DEBUG] ShapeCast hits:", hit_count)
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
