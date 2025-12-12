@tool
class_name TreeSpawner
extends Node3D
## Performant forest generator using MultiMeshInstance3D for GPU instancing
## Supports multiple tree mesh variations with noise-based distribution

@export_group("Tree Meshes")
## Array of tree meshes to randomly distribute across the forest
@export var tree_meshes: Array[ArrayMesh] = []:
	set(value):
		tree_meshes = value
		if Engine.is_editor_hint():
			_regenerate_deferred()

@export_group("Distribution")
## Total number of trees to generate
@export var tree_count: int = 1000:
	set(value):
		tree_count = value
		if Engine.is_editor_hint():
			_regenerate_deferred()
## Size of the forest area (XZ plane)
@export var area_size: Vector2 = Vector2(200, 200):
	set(value):
		area_size = value
		if Engine.is_editor_hint():
			_regenerate_deferred()
## Noise-based clustering strength (0 = uniform, 1 = strong clusters)
@export_range(0.0, 1.0) var clustering: float = 0.5:
	set(value):
		clustering = value
		if Engine.is_editor_hint():
			_regenerate_deferred()
## Minimum distance between trees (meters)
@export var min_tree_spacing: float = 3.0:
	set(value):
		min_tree_spacing = value
		if Engine.is_editor_hint():
			_regenerate_deferred()

@export_group("Variation")
## Scale variation range (min, max)
@export var scale_range: Vector2 = Vector2(0.8, 1.3):
	set(value):
		scale_range = value
		if Engine.is_editor_hint():
			_regenerate_deferred()
## Random seed for reproducible generation (0 = random each time)
@export var random_seed: int = 12345:
	set(value):
		random_seed = value
		if Engine.is_editor_hint():
			_regenerate_deferred()

@export_group("Ground Integration")
## Sink trees into ground to hide base (meters, positive = sink down)
@export var ground_sink: float = 0.1:
	set(value):
		ground_sink = value
		if Engine.is_editor_hint():
			_regenerate_deferred()
## Random variation in ground sink (0 = none, 1 = full range)
@export_range(0.0, 1.0) var sink_variation: float = 0.3:
	set(value):
		sink_variation = value
		if Engine.is_editor_hint():
			_regenerate_deferred()
## Align trees to terrain slope (experimental - requires terrain normals)
@export var align_to_slope: bool = false:
	set(value):
		align_to_slope = value
		if Engine.is_editor_hint():
			_regenerate_deferred()
## Maximum rotation angle for slope alignment (degrees)
@export_range(0.0, 45.0) var max_slope_angle: float = 15.0:
	set(value):
		max_slope_angle = value
		if Engine.is_editor_hint():
			_regenerate_deferred()

@export_group("Terrain Integration")
## Optional terrain mesh to sample height from
@export var terrain: MeshInstance3D:
	set(value):
		terrain = value
		if Engine.is_editor_hint():
			_regenerate_deferred()
## Vertical offset to apply to all trees
@export var height_offset: float = 0.0:
	set(value):
		height_offset = value
		if Engine.is_editor_hint():
			_regenerate_deferred()

@export_group("Editor")
## Click to regenerate forest in editor (creates new baked trees)
@export var regenerate_button: bool = false:
	set(value):
		if Engine.is_editor_hint() and value:
			regenerate()
		regenerate_button = false
## Click to clear all baked tree instances
@export var clear_trees_button: bool = false:
	set(value):
		if Engine.is_editor_hint() and value:
			clear_trees()
		clear_trees_button = false

var _multimesh_instances: Array[MultiMeshInstance3D] = []
var _instance_counters: Array[int] = []
var _noise: FastNoiseLite
var _regenerate_queued: bool = false


func _ready() -> void:
	_setup_noise()

	# Only generate in editor or if no baked trees exist
	if Engine.is_editor_hint():
		# In editor, trees will be generated via export setters
		pass
	else:
		# At runtime, check if we have baked children
		_collect_existing_multimeshes()
		if _multimesh_instances.is_empty():
			# No baked trees, generate at runtime
			_generate_forest()


## Deferred regeneration for editor updates
func _regenerate_deferred() -> void:
	if not is_inside_tree():
		return

	if _regenerate_queued:
		return

	_regenerate_queued = true
	call_deferred("_execute_regenerate")


## Execute the deferred regeneration
func _execute_regenerate() -> void:
	_regenerate_queued = false
	regenerate()


## Initialize noise generator for natural distribution
func _setup_noise() -> void:
	_noise = FastNoiseLite.new()
	_noise.seed = random_seed if random_seed != 0 else randi()
	_noise.noise_type = FastNoiseLite.TYPE_PERLIN
	_noise.frequency = 0.02


## Collect existing MultiMeshInstance3D children (for baked trees)
func _collect_existing_multimeshes() -> void:
	_multimesh_instances.clear()
	for child in get_children():
		if child is MultiMeshInstance3D:
			_multimesh_instances.append(child)


## Generate the entire forest
func _generate_forest() -> void:
	if tree_meshes.is_empty():
		LogService.warning("No tree meshes assigned.", "tree_spawner.gd:52")
		return

	# Seed random for reproducible generation
	if random_seed != 0:
		seed(random_seed)

	# Calculate trees per mesh type (evenly distributed)
	var mesh_count := tree_meshes.size()
	var trees_per_mesh := tree_count / mesh_count
	var remainder := tree_count % mesh_count

	# Create MultiMesh instances for each tree type
	_multimesh_instances.clear()
	_instance_counters.clear()
	for i in mesh_count:
		var mmi := MultiMeshInstance3D.new()
		mmi.name = "TreeMultiMesh_%d" % i
		add_child(mmi)

		# In editor, set owner so the node is saved with the scene
		if Engine.is_editor_hint():
			mmi.set_owner(get_tree().edited_scene_root)

		_multimesh_instances.append(mmi)
		_instance_counters.append(0)

		# Distribute remainder trees to first few meshes
		var count := trees_per_mesh + (1 if i < remainder else 0)
		_init_multimesh(mmi, tree_meshes[i], count)

	# Generate positions with spacing
	var positions := _generate_positions()

	# Distribute trees randomly across all mesh types
	var mesh_indices: Array[int] = []
	for i in mesh_count:
		var count := trees_per_mesh + (1 if i < remainder else 0)
		for j in count:
			mesh_indices.append(i)

	# Shuffle for random distribution
	mesh_indices.shuffle()

	# Place trees
	for i in positions.size():
		var mesh_idx := mesh_indices[i]
		var mmi := _multimesh_instances[mesh_idx]
		var instance_idx := _get_next_instance_index(mesh_idx)
		_place_tree(mmi, instance_idx, positions[i])


## Initialize a MultiMesh instance
func _init_multimesh(mmi: MultiMeshInstance3D, mesh: ArrayMesh, count: int) -> void:
	var mm := MultiMesh.new()
	mm.mesh = mesh
	mm.transform_format = MultiMesh.TRANSFORM_3D
	mm.instance_count = count
	mmi.multimesh = mm

	# Enable culling for performance
	mmi.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_ON
	mmi.visibility_range_end = 200.0
	mmi.visibility_range_end_margin = 20.0


## Generate tree positions with noise-based clustering and spacing
func _generate_positions() -> Array[Vector2]:
	var positions: Array[Vector2] = []
	var half_x := area_size.x * 0.5
	var half_z := area_size.y * 0.5

	# Use Poisson disk sampling approach for better spacing
	var attempts := 0
	var max_attempts := tree_count * 10  # Prevent infinite loops

	while positions.size() < tree_count and attempts < max_attempts:
		attempts += 1

		var pos := Vector2(randf_range(-half_x, half_x), randf_range(-half_z, half_z))

		# Apply noise-based rejection for clustering
		if clustering > 0.0:
			var noise_val := _noise.get_noise_2d(pos.x, pos.y)
			var threshold := 1.0 - clustering
			if noise_val < -threshold:
				continue

		# Check spacing
		if _check_spacing(positions, pos):
			positions.append(pos)

	return positions


## Check if position maintains minimum spacing from existing trees
func _check_spacing(positions: Array[Vector2], new_pos: Vector2) -> bool:
	if positions.is_empty():
		return true

	var min_dist_sq := min_tree_spacing * min_tree_spacing

	# Only check nearby trees for performance
	for pos in positions:
		if new_pos.distance_squared_to(pos) < min_dist_sq:
			return false

	return true


## Place a tree instance at the given position
func _place_tree(mmi: MultiMeshInstance3D, idx: int, pos_2d: Vector2) -> void:
	var y := height_offset

	# Sample terrain height
	var terrain_normal := Vector3.UP
	if terrain:
		var sample := _sample_terrain_height_and_normal(pos_2d)
		y = sample.height + height_offset
		terrain_normal = sample.normal

	# Apply ground sink with variation
	var sink_amount := ground_sink
	if sink_variation > 0.0:
		sink_amount += randf_range(-ground_sink * sink_variation, ground_sink * sink_variation)
	y -= sink_amount

	var pos := Vector3(pos_2d.x, y, pos_2d.y)
	var rot := randf_range(0.0, TAU)
	var scl := randf_range(scale_range.x, scale_range.y)

	# Build transform
	var t := Transform3D()

	# Apply slope alignment if enabled
	if align_to_slope and terrain_normal != Vector3.UP:
		# Calculate rotation to align Y axis with terrain normal
		var up_axis := Vector3.UP
		var rotation_axis := up_axis.cross(terrain_normal).normalized()

		if rotation_axis.length() > 0.001:
			var angle := up_axis.angle_to(terrain_normal)
			# Clamp angle to max_slope_angle
			angle = clamp(angle, 0.0, deg_to_rad(max_slope_angle))

			# Apply slope rotation first
			t = t.rotated(rotation_axis, angle)

	# Apply random Y rotation
	t = t.rotated(Vector3.UP, rot)

	# Apply scale
	t = t.scaled(Vector3(scl, scl, scl))

	# Set position
	t.origin = pos

	mmi.multimesh.set_instance_transform(idx, t)


## Sample terrain height at XZ position (simplified raycast approach)
func _sample_terrain_height(pos_2d: Vector2) -> float:
	var sample := _sample_terrain_height_and_normal(pos_2d)
	return sample.height


## Sample terrain height and normal at XZ position
func _sample_terrain_height_and_normal(pos_2d: Vector2) -> Dictionary:
	var result := {"height": 0.0, "normal": Vector3.UP}

	if not terrain:
		return result

	# Raycast down from above
	var space := get_world_3d().direct_space_state
	if not space:
		return result

	var from := Vector3(pos_2d.x, 100.0, pos_2d.y)
	var to := Vector3(pos_2d.x, -100.0, pos_2d.y)

	var query := PhysicsRayQueryParameters3D.create(from, to)
	query.collide_with_areas = false
	query.collide_with_bodies = true

	var hit := space.intersect_ray(query)
	if hit:
		result.height = hit.position.y
		if hit.has("normal"):
			result.normal = hit.normal

	return result


## Get and increment the instance index for a mesh type
func _get_next_instance_index(mesh_idx: int) -> int:
	var idx := _instance_counters[mesh_idx]
	_instance_counters[mesh_idx] += 1
	return idx


## Clear all baked tree instances
func clear_trees() -> void:
	for child in get_children():
		if child is MultiMeshInstance3D:
			child.queue_free()
	_multimesh_instances.clear()
	_instance_counters.clear()


## Regenerate forest (useful for editor tweaking)
func regenerate() -> void:
	clear_trees()
	_setup_noise()
	_generate_forest()
