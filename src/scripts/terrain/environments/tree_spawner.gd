@tool
class_name TreeSpawner
extends Node3D
## Tree spawner with LOD support using multiple MultiMeshInstances
## Each LOD level gets its own MultiMeshInstance with visibility_range

@export_group("Tree Meshes LOD")
## LOD0 - High detail meshes (closest 0-50m)
@export var tree_meshes_lod0: Array[ArrayMesh] = []:
	set(value):
		tree_meshes_lod0 = value
		if Engine.is_editor_hint():
			_regenerate_deferred()

## LOD1 - Medium detail meshes (50-100m)
@export var tree_meshes_lod1: Array[ArrayMesh] = []:
	set(value):
		tree_meshes_lod1 = value
		if Engine.is_editor_hint():
			_regenerate_deferred()

## LOD2 - Low detail meshes (100-200m)
@export var tree_meshes_lod2: Array[ArrayMesh] = []:
	set(value):
		tree_meshes_lod2 = value
		if Engine.is_editor_hint():
			_regenerate_deferred()

@export_group("LOD Distances")
## LOD0 visible from 0 to this distance (meters)
@export var lod0_distance: float = 50.0
## LOD1 visible from LOD0 to this distance (meters)
@export var lod1_distance: float = 100.0
## LOD2 visible from LOD1 to this distance (meters)
@export var lod2_distance: float = 200.0
## Fade transition margin (meters)
@export var lod_fade_margin: float = 10.0

@export_group("Distribution")
## Total number of trees to generate (applies to ALL LODs)
@export var tree_count: int = 300:
	set(value):
		tree_count = value
		if Engine.is_editor_hint():
			_regenerate_deferred()

## Size of the forest area (XZ plane)
@export var area_size: Vector2 = Vector2(50, 50):
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
@export var min_tree_spacing: float = 2.5:
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
## Click to regenerate forest with LODs
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

var _noise: FastNoiseLite
var _regenerate_queued: bool = false
var _tree_transforms: Array[Transform3D] = []  # Shared transforms for all LODs


func _ready() -> void:
	_setup_noise()
	if not Engine.is_editor_hint():
		# At runtime, check if we have baked children
		if get_child_count() == 0:
			_generate_forest_all_lods()


func _regenerate_deferred() -> void:
	if not is_inside_tree() or _regenerate_queued:
		return
	_regenerate_queued = true
	call_deferred("_execute_regenerate")


func _execute_regenerate() -> void:
	_regenerate_queued = false
	regenerate()


func _setup_noise() -> void:
	_noise = FastNoiseLite.new()
	_noise.noise_type = FastNoiseLite.TYPE_PERLIN
	_noise.frequency = 0.05
	_noise.seed = random_seed if random_seed != 0 else randi()


## Main regeneration function
func regenerate() -> void:
	print("[TreeSpawner] Regenerating forest with LODs...")
	clear_trees()

	# Generate tree transforms (shared by all LODs)
	_generate_tree_transforms()

	# Create MultiMesh for each LOD level
	_create_multimesh_lods()

	print("[TreeSpawner] Generated %d trees across %d LOD levels" % [_tree_transforms.size(), _count_lod_levels()])


## Clear all tree instances
func clear_trees() -> void:
	for child in get_children():
		if Engine.is_editor_hint():
			child.owner = null
		child.queue_free()
	_tree_transforms.clear()


## Generate tree transforms (positions, rotations, scales)
func _generate_tree_transforms() -> void:
	_tree_transforms.clear()

	if random_seed != 0:
		seed(random_seed)

	var half_size := area_size / 2.0
	var placed := 0
	var attempts := 0
	var max_attempts := tree_count * 20

	while placed < tree_count and attempts < max_attempts:
		attempts += 1

		# Generate position
		var pos_2d := Vector2(randf_range(-half_size.x, half_size.x), randf_range(-half_size.y, half_size.y))

		# Apply clustering
		var noise_val := (_noise.get_noise_2d(pos_2d.x, pos_2d.y) + 1.0) / 2.0
		if randf() > lerp(1.0, noise_val, clustering):
			continue

		# Check spacing
		if not _check_spacing(pos_2d):
			continue

		# Sample terrain height
		var y_pos := _sample_terrain_height(pos_2d) + height_offset
		var sink_amount := ground_sink + randf_range(-sink_variation, sink_variation) * ground_sink
		var pos_3d := Vector3(pos_2d.x, y_pos - sink_amount, pos_2d.y)

		# Generate transform
		var t := Transform3D()
		t = t.rotated(Vector3.UP, randf() * TAU)  # Random Y rotation

		# Optionally align to slope
		if align_to_slope:
			var slope_normal := _sample_terrain_normal(pos_2d)
			if slope_normal != Vector3.UP:
				var angle := Vector3.UP.angle_to(slope_normal)
				if angle > deg_to_rad(max_slope_angle):
					continue  # Skip if slope too steep
				# Apply slope rotation
				var axis := Vector3.UP.cross(slope_normal).normalized()
				t = t.rotated(axis, angle)

		t = t.scaled(Vector3.ONE * randf_range(scale_range.x, scale_range.y))
		t.origin = pos_3d

		_tree_transforms.append(t)
		placed += 1

	if placed < tree_count:
		push_warning("[TreeSpawner] Only placed %d/%d trees due to spacing constraints" % [placed, tree_count])


func _check_spacing(pos: Vector2) -> bool:
	for t in _tree_transforms:
		var existing_pos := Vector2(t.origin.x, t.origin.z)
		if pos.distance_to(existing_pos) < min_tree_spacing:
			return false
	return true


func _sample_terrain_height(pos_2d: Vector2) -> float:
	if terrain == null:
		return 0.0

	# Simple raycast down from above
	var space_state := get_world_3d().direct_space_state
	if space_state == null:
		return 0.0

	var query := PhysicsRayQueryParameters3D.create(
		global_position + Vector3(pos_2d.x, 100, pos_2d.y),
		global_position + Vector3(pos_2d.x, -100, pos_2d.y)
	)
	var result := space_state.intersect_ray(query)
	if result:
		return result.position.y
	return 0.0


func _sample_terrain_normal(pos_2d: Vector2) -> Vector3:
	if terrain == null:
		return Vector3.UP

	var space_state := get_world_3d().direct_space_state
	if space_state == null:
		return Vector3.UP

	var query := PhysicsRayQueryParameters3D.create(
		global_position + Vector3(pos_2d.x, 100, pos_2d.y),
		global_position + Vector3(pos_2d.x, -100, pos_2d.y)
	)
	var result := space_state.intersect_ray(query)
	if result:
		return result.normal
	return Vector3.UP


func _count_lod_levels() -> int:
	var count := 0
	if not tree_meshes_lod0.is_empty():
		count += 1
	if not tree_meshes_lod1.is_empty():
		count += 1
	if not tree_meshes_lod2.is_empty():
		count += 1
	return count


## Create MultiMeshInstance for each LOD level
func _create_multimesh_lods() -> void:
	if _tree_transforms.is_empty():
		push_warning("[TreeSpawner] No tree transforms generated")
		return

	# LOD0 - High detail
	if not tree_meshes_lod0.is_empty():
		_create_lod_level(tree_meshes_lod0, 0, lod0_distance, "LOD0")

	# LOD1 - Medium detail
	if not tree_meshes_lod1.is_empty():
		_create_lod_level(tree_meshes_lod1, lod0_distance, lod1_distance, "LOD1")

	# LOD2 - Low detail
	if not tree_meshes_lod2.is_empty():
		_create_lod_level(tree_meshes_lod2, lod1_distance, lod2_distance, "LOD2")


func _create_lod_level(meshes: Array[ArrayMesh], dist_begin: float, dist_end: float, lod_name: String) -> void:
	var mesh_count := meshes.size()
	if mesh_count == 0:
		return

	# Group transforms by mesh type
	var transforms_by_mesh: Array[Array] = []
	for i in mesh_count:
		transforms_by_mesh.append([])

	# Distribute transforms across mesh types
	for i in _tree_transforms.size():
		var mesh_idx := i % mesh_count
		transforms_by_mesh[mesh_idx].append(_tree_transforms[i])

	# Create MultiMeshInstance for each mesh type
	for mesh_idx in mesh_count:
		if transforms_by_mesh[mesh_idx].is_empty():
			continue

		var mmi := MultiMeshInstance3D.new()
		mmi.name = "TreeMultiMesh_%s_%d" % [lod_name, mesh_idx + 1]

		# Set visibility range
		mmi.visibility_range_begin = dist_begin
		mmi.visibility_range_end = dist_end
		mmi.visibility_range_begin_margin = lod_fade_margin
		mmi.visibility_range_end_margin = lod_fade_margin
		# FADE_DEPENDENCIES keeps shadows visible even when mesh is culled
		mmi.visibility_range_fade_mode = GeometryInstance3D.VISIBILITY_RANGE_FADE_DEPENDENCIES

		# Enable shadow casting for all LODs
		mmi.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_ON
		# Keep shadows visible even when mesh is culled by visibility range
		mmi.extra_cull_margin = 16384.0  # Large value to ensure shadows render at distance

		# Create MultiMesh
		var mm := MultiMesh.new()
		mm.transform_format = MultiMesh.TRANSFORM_3D
		mm.mesh = meshes[mesh_idx]
		mm.instance_count = transforms_by_mesh[mesh_idx].size()

		# Set transforms
		for i in mm.instance_count:
			mm.set_instance_transform(i, transforms_by_mesh[mesh_idx][i])

		mmi.multimesh = mm
		add_child(mmi)

		# Make persistent in editor
		if Engine.is_editor_hint():
			mmi.owner = get_tree().edited_scene_root

		print("[TreeSpawner] Created %s with %d instances (visibility: %.1fm-%.1fm)" % [mmi.name, mm.instance_count, dist_begin, dist_end])


func _generate_forest_all_lods() -> void:
	_generate_tree_transforms()
	_create_multimesh_lods()
