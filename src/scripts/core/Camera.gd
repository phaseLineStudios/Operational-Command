# Script for camera behaviour in the 3d scenes (mainly for hq_table.tscn)
# Attach it to the CameraRig Node3D that has a camera as a child
# Scene suggestion:
#   CameraRig (this script)
#     └─ PitchPivot (Node3D)
#         └─ Camera3D
# Responsibilities:
#   - CameraRig: horizontal movement over the table (XZ), fixed hover height (Y), clamping to table bounds.
#   - PitchPivot: up/down pitch rotation; Camera3D inherits this rotation.

extends Node3D

# variables for the camera
@export var move_speed: float = 1.0      # linear speed in units/sec for WASD motion on XZ plane
@export var accel: float = 5.0           # responsiveness; higher = snappier acceleration/deceleration
@export var hover_offset: float = 0.2    # vertical offset above detected tabletop (_top_y)

# Bounds source
@export_group("Table bounds")
@export var table_node: NodePath         # node containing the table meshes; used to auto-detect world AABB
@export var edge_padding: float = 0.05   # keeps rig slightly inside edges to avoid visual clipping
# shift plane along +Z (relative to table)
# needed because the camera does not look straight down
@export var forward_offset: float = 0.35  # shifts the clamped rectangle forward/back along Z once at init

# variables used for tilting the camera near z edge of the table
@export_group("Tilt near Z edge")
@export var default_pitch_deg: float = -30.0  # base downward tilt applied to PitchPivot at startup
@export var max_edge_tilt_deg: float = 30.0   # additional downward tilt when close to chosen Z edge
@export var tilt_start_distance: float = 1  # distance-from-edge where tilt begins ramping in
@export var tilt_lerp_speed: float = 20.0     # interpolation speed for smooth pitch changes each frame
@onready var pitch_pivot: Node3D = $PitchPivot # pivot node that actually rotates around local X (pitch)

# create a 0 velicity vector
var _vel: Vector3 = Vector3.ZERO          # current horizontal velocity used for smooth acceleration

# Resolved world-space bounds
var _bx_min := 0.0                        # world-space min X of table clamp rectangle
var _bx_max := 0.0                        # world-space max X of table clamp rectangle
var _bz_min := 0.0                        # world-space min Z of table clamp rectangle (used as "far" edge here)
var _bz_max := 0.0                        # world-space max Z of table clamp rectangle
var _top_y  := 0.0                        # world-space Y of tabletop surface (AABB top)
var _bounds_ready := false                # becomes true once bounds are computed; movement then clamps

# Runs whenever the scene is loaded, after all nodes are loaded
func _ready():
	# Initialize the table bounds, used to limit the camera movement to the table only
	_init_table_bounds()
	# if the camera was found, perform the default tilt
	if pitch_pivot:
		# sets initial viewing angle; Camera3D should remain unrotated so pitch is centralized here
		pitch_pivot.rotation_degrees.x = default_pitch_deg
	# Lock and hide the mouse, makes the game more immersive
	# IMPORTANT: UNCOMMENT THIS LINE IF THE MOUSE NEEDS TO BE CAPTURED
	# NO LONGER NEED FOR NOW BUT MAYBE IN THE FUTURE
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

# called every physics frame (like 60Hz)
# ideal for movement, collisions and gravity
# since _process should not be used for player movement, use _physics_process for this
func _physics_process(delta: float) -> void:
	# handling the inputs by the player
	# Input map expected: move_forward/back/left/right
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
	# desired_vel is the target horizontal velocity from input; lerp provides smooth acceleration
	var desired_vel := input_direction * move_speed
	_vel = _vel.lerp(desired_vel, clamp(accel * delta, 0.0, 1.0))	
		
	# Apply movement
	# position is updated using velocity; motion is frame-rate independent due to * delta
	var pos := global_position
	pos += _vel * delta
	
	# Keep the camera locked to the hover plane above the table
	# Use the bounds that are calcualted in _init_table_bounds() in _ready()
	# should only be executed when the bounds are calculated, may take some physics frame
	# therefore, we use the _bounds_ready boolean variable to indicate when the process is finished
	if _bounds_ready:
		# enforce fixed hover height over the detected tabletop
		pos.y = _top_y + hover_offset

		# Clamp to table rectangle
		# clamps X and Z so the rig remains on/over the table footprint with padding
		pos.x = clamp(pos.x, _bx_min + edge_padding, _bx_max - edge_padding)
		pos.z = clamp(pos.z, _bz_min + edge_padding, _bz_max - edge_padding)
		
		# this is the logic to tilt the camera at the end of z bounds
		if pitch_pivot:
			# Distance to the far Z edge
			# current configuration treats _bz_min as the "far" edge; flip to _bz_max if table orientation differs
			var dist_edge: float = abs(pos.z - _bz_min)

			# Compute normalized proximity factor t in [0,1]:
			#  - t = 0 when farther than tilt_start_distance (no extra tilt)
			#  - t = 1 when exactly at the edge (full extra tilt)
			var t: float = 0.0
			if tilt_start_distance > 0.0:
				t = 1.0 - clamp(dist_edge / tilt_start_distance, 0.0, 1.0)
				# smoothstep curve for softer easing near start/end
				t = t * t * (3.0 - 2.0 * t)

			# Target pitch: base tilt plus additional downward tilt based on proximity factor
			var target_pitch: float = default_pitch_deg - max_edge_tilt_deg * t
			# Interpolation factor k for smooth convergence toward target pitch
			var k: float = clamp(tilt_lerp_speed * delta, 0.0, 1.0)
			# Apply pitch to the pivot only; Camera3D remains unrotated so all pitch is centralized
			pitch_pivot.rotation_degrees.x = lerp(pitch_pivot.rotation_degrees.x, target_pitch, k)
	# write back updated position after optional clamping and tilt calculation
	global_position = pos
		

# --- Bounds detection ---
# SHOULD ONLY BE CALLED FROM _ready() FUNCTION ON STARTUP
# AND NOT EVERY FRAME
func _init_table_bounds() -> void:
	# Guard: require a valid NodePath set via Inspector
	if table_node == NodePath():
		push_warning("table_node not set. CameraRig will not clamp.")
		return

	# Resolve the node path to a scene node
	var root := get_node_or_null(table_node)
	if root == null:
		push_warning("table_node path not found. CameraRig will not clamp.")
		return

	# Recursively gather all MeshInstance3D descendants to compute a merged AABB
	var meshes := _gather_meshes(root)
	if meshes.is_empty():
		push_warning("No MeshInstance3D found under table_node. CameraRig will not clamp.")
		return

	# Merge world-space AABBs of all meshes to get overall bounds of the table
	var world_aabb := _world_aabb_for_mesh(meshes[0])
	for i in range(1, meshes.size()):
		world_aabb = world_aabb.merge(_world_aabb_for_mesh(meshes[i]))

	# Extract clamp rectangle and top surface from the merged AABB
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
	
	# Signal that bounds are ready; movement loop will now lock Y and clamp X/Z
	_bounds_ready = true

func _gather_meshes(n: Node) -> Array:
	# Depth-first search for MeshInstance3D nodes under the given root node
	var out: Array = []
	if n is MeshInstance3D:
		out.append(n)
	for c in n.get_children():
		out += _gather_meshes(c)
	return out

func _world_aabb_for_mesh(mi: MeshInstance3D) -> AABB:
	# Obtain mesh-local AABB and transform it to world space by transforming its 8 corners
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
	# Transform the first local-space corner to world-space.
	# Use it to initialize both running min and max.
	var w0: Vector3 = xf * corners[0]
	var min_v: Vector3 = w0
	var max_v: Vector3 = w0

	# Visit the remaining 7 corners (1..7), transform each to world-space,
	# and expand the running min/max component-wise to enclose them all.
	for i in range(1, corners.size()):
		var w: Vector3 = xf * corners[i]   # world-space position of this corner
		min_v = min_v.min(w)               # per-component minimum (x, y, z)
		max_v = max_v.max(w)               # per-component maximum (x, y, z)

	# Build the world-space AABB:
	#  - position = min corner (min_v)
	#  - size     = max - min (component-wise extent along x, y, z)
	return AABB(min_v, max_v - min_v)
