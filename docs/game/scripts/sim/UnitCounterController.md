# UnitCounterController Class Reference

*File:* `scripts/sim/UnitCounterController.gd`
*Class name:* `UnitCounterController`
*Inherits:* `Node`

## Synopsis

```gdscript
class_name UnitCounterController
extends Node
```

## Brief

Opens CounterConfigDialog when the user clicks the 3D drawer and spawns counters.

## Detailed Description

Spawns a unit counter with the requested parameters.
`p_affiliation` The unit's affiliation (friend, enemy, etc.)
`p_type` The unit type (infantry, armor, etc.)
`p_size` The unit size/echelon (company, battalion, etc.)
`p_callsign` The unit's callsign identifier

Spawn a unit counter at a specific terrain position.
Used for automatic counter spawning (e.g., on contact spotted).
`p_affiliation` The unit's affiliation (friend, enemy, etc.)
`p_type` The unit type (infantry, armor, etc.)
`p_size` The unit size/echelon (company, battalion, etc.)
`p_callsign` The unit's callsign identifier
`pos_m` Position in terrain meters (Vector2)

## Public Member Functions

- [`func _ready() -> void`](UnitCounterController/functions/_ready.md)
- [`func _on_drawer_input_event(_cam, event: InputEvent, _pos, _norm, _shape_idx) -> void`](UnitCounterController/functions/_on_drawer_input_event.md) — Handles click on the drawer and pops the dialog.
- [`func get_counter_count() -> int`](UnitCounterController/functions/get_counter_count.md) — Get the total number of counters created by the player.
- [`func init(map_mesh: MeshInstance3D, terrain_render: TerrainRender) -> void`](UnitCounterController/functions/init.md) — Initialize references for coordinate conversion.
- [`func _terrain_to_world(pos_m: Vector2) -> Variant`](UnitCounterController/functions/_terrain_to_world.md) — Convert terrain 2D position to 3D world position on the map.

## Public Attributes

- `StaticBody3D drawer` — The 3D drawer object (must have a CollisionShape3D).
- `CounterConfigDialog counter_dialog` — The UI dialog to show when clicked.
- `int _counter_count` — Track the number of counters created
- `MeshInstance3D _map_mesh` — Reference to map mesh for coordinate conversion
- `TerrainRender _terrain_render` — Reference to terrain renderer for coordinate conversion
- `UnitCounter counter`
- `Marker3D spawn_location`
- `Variant world_pos`

## Member Function Documentation

### _ready

```gdscript
func _ready() -> void
```

### _on_drawer_input_event

```gdscript
func _on_drawer_input_event(_cam, event: InputEvent, _pos, _norm, _shape_idx) -> void
```

Handles click on the drawer and pops the dialog.
`_cam` Unused camera reference.
`event` The input event to check for mouse clicks.
`_pos` Unused hit position.
`_norm` Unused hit normal.
`_shape_idx` Unused shape index.

### get_counter_count

```gdscript
func get_counter_count() -> int
```

Get the total number of counters created by the player.
Used by TriggerAPI to detect counter creation.
[return] Number of counters created.

### init

```gdscript
func init(map_mesh: MeshInstance3D, terrain_render: TerrainRender) -> void
```

Initialize references for coordinate conversion.
`map_mesh` MeshInstance3D of the map plane
`terrain_render` TerrainRender for terrain data

### _terrain_to_world

```gdscript
func _terrain_to_world(pos_m: Vector2) -> Variant
```

Convert terrain 2D position to 3D world position on the map.
`pos_m` Terrain position in meters.
[return] World position as Vector3, or null if conversion fails.

## Member Data Documentation

### drawer

```gdscript
var drawer: StaticBody3D
```

Decorators: `@export`

The 3D drawer object (must have a CollisionShape3D).

### counter_dialog

```gdscript
var counter_dialog: CounterConfigDialog
```

Decorators: `@export`

The UI dialog to show when clicked.

### _counter_count

```gdscript
var _counter_count: int
```

Track the number of counters created

### _map_mesh

```gdscript
var _map_mesh: MeshInstance3D
```

Reference to map mesh for coordinate conversion

### _terrain_render

```gdscript
var _terrain_render: TerrainRender
```

Reference to terrain renderer for coordinate conversion

### counter

```gdscript
var counter: UnitCounter
```

### spawn_location

```gdscript
var spawn_location: Marker3D
```

### world_pos

```gdscript
var world_pos: Variant
```
