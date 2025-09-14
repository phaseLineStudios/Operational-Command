# Script for camera behaviour in the 3d scenes (mainly for hq_table.tscn)
# Attach it to the CameraRig Node3D that has a camera as a child

extends Node3D

# variables for the camera
@export var move_speed: float = 1.0
@export var accel: float = 5.0
@export var table_top_y: float = 0.8   # height of the table surface
@export var hover_offset: float = 0.2  # how high above the table the camera floats

var _vel: Vector3 = Vector3.ZERO

# Runs whenever the scene is loaded, after all nodes are loaded
func _ready():
	# Lock and hide the mouse, makes the game more immersive
	# IMPORTANT: UNCOMMENT THIS LINE IF THE MOUSE NEEDS TO BE CAPTURED
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass

# called every physics frame (like 60Hz)
# ideal for movement, collisions and gravity
# since _process should not be used for player movement, use _physics_process for this
func _physics_process(delta: float) -> void:

	# handling the inputs by the player
	var input_direction := Vector3.ZERO
	if Input.is_action_pressed("move_forward"):
		input_direction.z -= 1.0
	if Input.is_action_pressed("move_back"):
		input_direction.z += 1.0
	if Input.is_action_pressed("move_left"):
		input_direction.x -= 1.0
	if Input.is_action_pressed("move_right"):
		input_direction.x += 1.0

	# normalize vector so diagonal movement is not faster
	# this just checks if a key was pressed and then normalized the vector
	if input_direction.length() > 0.001:
		input_direction = input_direction.normalized()
	
	# Smooth velocity
	var desired_vel := input_direction * move_speed
	_vel = _vel.lerp(desired_vel, clamp(accel * delta, 0.0, 1.0))	
		
	# Apply movement
	var pos := global_position
	pos += _vel * delta
	
	# Keep the camera locked to the hover plane above the table
	pos.y = table_top_y + hover_offset
	global_position = pos
		
