# Script for camera behaviour in the 3d scenes (mainly for hq_table.tscn)
# Attach it to the CameraRig Node3D that has a camera as a child

extends Node3D

# variables for the camera
@export var move_speed: float = 1.0
@export var accel: float = 5.0
@export var hover_offset: float = 0.2  # how high above the table the camera floats

# Bounds source
@export_group("Table bounds")
@export var table_node: NodePath        # Point to the table mesh node, set in the inspector
@export var edge_padding: float = 0.05  # Keep the rig slightly inside the edge
# shift plane along +Z (relative to table)
# needed because the camera does not look straight down
@export var forward_offset: float = 0.3


var _vel: Vector3 = Vector3.ZERO

# Resolved world-space bounds
var _bx_min := 0.0
var _bx_max := 0.0
var _bz_min := 0.0
var _bz_max := 0.0
var _top_y  := 0.0
var _bounds_ready := false

# Runs whenever the scene is loaded, after all nodes are loaded
func _ready():
	# Initialize the table bounds, used to limit the camera movement to the table only
	_init_table_bounds()
	# Lock and hide the mouse, makes the game more immersive
	# IMPORTANT: UNCOMMENT THIS LINE IF THE MOUSE NEEDS TO BE CAPTURED
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

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
	# Use the bounds that are calcualted in _init_table_bounds() in _ready()
	# should only be executed when the bounds are calculated, may take some physics frame
	# therefore, we use the _bounds_ready boolean variable to indicate when the process is finished
	if _bounds_ready:
		pos.y = _top_y + hover_offset

		# Clamp to table rectangle
		pos.x = clamp(pos.x, _bx_min + edge_padding, _bx_max - edge_padding)
		pos.z = clamp(pos.z, _bz_min + edge_padding, _bz_max - edge_padding)
	global_position = pos
		

# --- Bounds detection ---
# SHOULD ONLY BE CALLED FROM _ready() FUNCTION ON STARTUP
# AND NOT EVERY FRAME
func _init_table_bounds() -> void:
	if table_node == NodePath():
		push_warning("table_node not set. CameraRig will not clamp.")
		return

	var root := get_node_or_null(table_node)
	if root == null:
		push_warning("table_node path not found. CameraRig will not clamp.")
		return

	var meshes := _gather_meshes(root)
	if meshes.is_empty():
		push_warning("No MeshInstance3D found under table_node. CameraRig will not clamp.")
		return

	var world_aabb := _world_aabb_for_mesh(meshes[0])
	for i in range(1, meshes.size()):
		world_aabb = world_aabb.merge(_world_aabb_for_mesh(meshes[i]))

	_bx_min = world_aabb.position.x
	_bz_min = world_aabb.position.z
	_bx_max = world_aabb.position.x + world_aabb.size.x
	_bz_max = world_aabb.position.z + world_aabb.size.z
	_top_y  = world_aabb.position.y + world_aabb.size.y
	
	# Apply forward offset for the camera
	# the forward offest is needed to view the front of the table
	# bounds are exaclty on the table, therefore we can just aply the offset
	_bz_min += forward_offset
	_bz_max += forward_offset
	
	_bounds_ready = true

func _gather_meshes(n: Node) -> Array:
	var out: Array = []
	if n is MeshInstance3D:
		out.append(n)
	for c in n.get_children():
		out += _gather_meshes(c)
	return out

func _world_aabb_for_mesh(mi: MeshInstance3D) -> AABB:
	var aabb: AABB = mi.get_aabb()
	var xf: Transform3D = mi.global_transform

	# Transform 8 corners into world space
	var corners := [
		aabb.position,
		aabb.position + Vector3(aabb.size.x, 0, 0),
		aabb.position + Vector3(0, aabb.size.y, 0),
		aabb.position + Vector3(0, 0, aabb.size.z),
		aabb.position + Vector3(aabb.size.x, aabb.size.y, 0),
		aabb.position + Vector3(aabb.size.x, 0, aabb.size.z),
		aabb.position + Vector3(0, aabb.size.y, aabb.size.z),
		aabb.position + aabb.size
	]
	var w0: Vector3 = xf * corners[0]
	var min_v: Vector3 = w0
	var max_v: Vector3 = w0
	for i in range(1, corners.size()):
		var w: Vector3 = xf * corners[i]
		min_v = min_v.min(w)
		max_v = max_v.max(w)
	return AABB(min_v, max_v - min_v)
