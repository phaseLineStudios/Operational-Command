# TreeSpawner Class Reference

*File:* `scripts/terrain/environments/tree_spawner.gd`
*Class name:* `TreeSpawner`
*Inherits:* `Node3D`

## Synopsis

```gdscript
class_name TreeSpawner
extends Node3D
```

## Brief

Tree spawner with LOD support using multiple MultiMeshInstances

## Detailed Description

Each LOD level gets its own MultiMeshInstance with visibility_range

## Public Member Functions

- [`func _ready() -> void`](TreeSpawner/functions/_ready.md)
- [`func _regenerate_deferred() -> void`](TreeSpawner/functions/_regenerate_deferred.md)
- [`func _execute_regenerate() -> void`](TreeSpawner/functions/_execute_regenerate.md)
- [`func _setup_noise() -> void`](TreeSpawner/functions/_setup_noise.md)
- [`func regenerate() -> void`](TreeSpawner/functions/regenerate.md) — Main regeneration function
- [`func clear_trees() -> void`](TreeSpawner/functions/clear_trees.md) — Clear all tree instances
- [`func _generate_tree_transforms() -> void`](TreeSpawner/functions/_generate_tree_transforms.md) — Generate tree transforms (positions, rotations, scales)
- [`func _check_spacing(pos: Vector2) -> bool`](TreeSpawner/functions/_check_spacing.md)
- [`func _sample_terrain_height(pos_2d: Vector2) -> float`](TreeSpawner/functions/_sample_terrain_height.md)
- [`func _sample_terrain_normal(pos_2d: Vector2) -> Vector3`](TreeSpawner/functions/_sample_terrain_normal.md)
- [`func _count_lod_levels() -> int`](TreeSpawner/functions/_count_lod_levels.md)
- [`func _create_multimesh_lods() -> void`](TreeSpawner/functions/_create_multimesh_lods.md) — Create MultiMeshInstance for each LOD level
- [`func _generate_forest_all_lods() -> void`](TreeSpawner/functions/_generate_forest_all_lods.md)

## Public Attributes

- `Array[ArrayMesh] tree_meshes_lod0` — LOD0 - High detail meshes (closest 0-50m)
- `Array[ArrayMesh] tree_meshes_lod1` — LOD1 - Medium detail meshes (50-100m)
- `Array[ArrayMesh] tree_meshes_lod2` — LOD2 - Low detail meshes (100-200m)
- `float lod0_distance` — LOD0 visible from 0 to this distance (meters)
- `float lod1_distance` — LOD1 visible from LOD0 to this distance (meters)
- `float lod2_distance` — LOD2 visible from LOD1 to this distance (meters)
- `float lod_fade_margin` — Fade transition margin (meters)
- `int tree_count` — Total number of trees to generate (applies to ALL LODs)
- `Vector2 area_size` — Size of the forest area (XZ plane)
- `float clustering` — Noise-based clustering strength (0 = uniform, 1 = strong clusters)
- `float min_tree_spacing` — Minimum distance between trees (meters)
- `Vector2 scale_range` — Scale variation range (min, max)
- `int random_seed` — Random seed for reproducible generation (0 = random each time)
- `float ground_sink` — Sink trees into ground to hide base (meters, positive = sink down)
- `float sink_variation` — Random variation in ground sink (0 = none, 1 = full range)
- `bool align_to_slope` — Align trees to terrain slope (experimental - requires terrain normals)
- `float max_slope_angle` — Maximum rotation angle for slope alignment (degrees)
- `MeshInstance3D: terrain` — Optional terrain mesh to sample height from
- `float height_offset` — Vertical offset to apply to all trees
- `bool regenerate_button` — Click to regenerate forest with LODs
- `bool clear_trees_button` — Click to clear all baked tree instances
- `FastNoiseLite _noise`
- `bool _regenerate_queued`
- `Array[Transform3D] _tree_transforms`
- `Array[Array] transforms_by_mesh`

## Member Function Documentation

### _ready

```gdscript
func _ready() -> void
```

### _regenerate_deferred

```gdscript
func _regenerate_deferred() -> void
```

### _execute_regenerate

```gdscript
func _execute_regenerate() -> void
```

### _setup_noise

```gdscript
func _setup_noise() -> void
```

### regenerate

```gdscript
func regenerate() -> void
```

Main regeneration function

### clear_trees

```gdscript
func clear_trees() -> void
```

Clear all tree instances

### _generate_tree_transforms

```gdscript
func _generate_tree_transforms() -> void
```

Generate tree transforms (positions, rotations, scales)

### _check_spacing

```gdscript
func _check_spacing(pos: Vector2) -> bool
```

### _sample_terrain_height

```gdscript
func _sample_terrain_height(pos_2d: Vector2) -> float
```

### _sample_terrain_normal

```gdscript
func _sample_terrain_normal(pos_2d: Vector2) -> Vector3
```

### _count_lod_levels

```gdscript
func _count_lod_levels() -> int
```

### _create_multimesh_lods

```gdscript
func _create_multimesh_lods() -> void
```

Create MultiMeshInstance for each LOD level

### _generate_forest_all_lods

```gdscript
func _generate_forest_all_lods() -> void
```

## Member Data Documentation

### tree_meshes_lod0

```gdscript
var tree_meshes_lod0: Array[ArrayMesh]
```

Decorators: `@export`

LOD0 - High detail meshes (closest 0-50m)

### tree_meshes_lod1

```gdscript
var tree_meshes_lod1: Array[ArrayMesh]
```

Decorators: `@export`

LOD1 - Medium detail meshes (50-100m)

### tree_meshes_lod2

```gdscript
var tree_meshes_lod2: Array[ArrayMesh]
```

Decorators: `@export`

LOD2 - Low detail meshes (100-200m)

### lod0_distance

```gdscript
var lod0_distance: float
```

Decorators: `@export`

LOD0 visible from 0 to this distance (meters)

### lod1_distance

```gdscript
var lod1_distance: float
```

Decorators: `@export`

LOD1 visible from LOD0 to this distance (meters)

### lod2_distance

```gdscript
var lod2_distance: float
```

Decorators: `@export`

LOD2 visible from LOD1 to this distance (meters)

### lod_fade_margin

```gdscript
var lod_fade_margin: float
```

Decorators: `@export`

Fade transition margin (meters)

### tree_count

```gdscript
var tree_count: int
```

Decorators: `@export`

Total number of trees to generate (applies to ALL LODs)

### area_size

```gdscript
var area_size: Vector2
```

Decorators: `@export`

Size of the forest area (XZ plane)

### clustering

```gdscript
var clustering: float
```

Decorators: `@export_range(0.0, 1.0)`

Noise-based clustering strength (0 = uniform, 1 = strong clusters)

### min_tree_spacing

```gdscript
var min_tree_spacing: float
```

Decorators: `@export`

Minimum distance between trees (meters)

### scale_range

```gdscript
var scale_range: Vector2
```

Decorators: `@export`

Scale variation range (min, max)

### random_seed

```gdscript
var random_seed: int
```

Decorators: `@export`

Random seed for reproducible generation (0 = random each time)

### ground_sink

```gdscript
var ground_sink: float
```

Decorators: `@export`

Sink trees into ground to hide base (meters, positive = sink down)

### sink_variation

```gdscript
var sink_variation: float
```

Decorators: `@export_range(0.0, 1.0)`

Random variation in ground sink (0 = none, 1 = full range)

### align_to_slope

```gdscript
var align_to_slope: bool
```

Decorators: `@export`

Align trees to terrain slope (experimental - requires terrain normals)

### max_slope_angle

```gdscript
var max_slope_angle: float
```

Decorators: `@export_range(0.0, 45.0)`

Maximum rotation angle for slope alignment (degrees)

### terrain

```gdscript
var terrain: MeshInstance3D:
```

Decorators: `@export`

Optional terrain mesh to sample height from

### height_offset

```gdscript
var height_offset: float
```

Decorators: `@export`

Vertical offset to apply to all trees

### regenerate_button

```gdscript
var regenerate_button: bool
```

Decorators: `@export`

Click to regenerate forest with LODs

### clear_trees_button

```gdscript
var clear_trees_button: bool
```

Decorators: `@export`

Click to clear all baked tree instances

### _noise

```gdscript
var _noise: FastNoiseLite
```

### _regenerate_queued

```gdscript
var _regenerate_queued: bool
```

### _tree_transforms

```gdscript
var _tree_transforms: Array[Transform3D]
```

### transforms_by_mesh

```gdscript
var transforms_by_mesh: Array[Array]
```
