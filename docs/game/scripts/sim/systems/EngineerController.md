# EngineerController Class Reference

*File:* `scripts/sim/systems/EngineerController.gd`
*Class name:* `EngineerController`
*Inherits:* `Node`

## Synopsis

```gdscript
class_name EngineerController
extends Node
```

## Brief

Manages engineer tasks: laying mines, demo charges, and building bridges.

## Detailed Description

Responsibilities:
- Identify engineer-capable units from equipment
- Process engineer task orders (mine, demo, bridge)
- Simulate task completion time
- Emit signals for voice responses (confirm, start, complete)
- Consume engineer ammunition from AmmoSystem

Active engineer task data

## Public Member Functions

- [`func _ready() -> void`](EngineerController/functions/_ready.md)
- [`func register_unit(unit_id: String, u: UnitData) -> void`](EngineerController/functions/register_unit.md) — Register a unit and check if it's engineer-capable.
- [`func unregister_unit(unit_id: String) -> void`](EngineerController/functions/unregister_unit.md) — Unregister a unit
- [`func set_unit_position(unit_id: String, pos: Vector2) -> void`](EngineerController/functions/set_unit_position.md) — Update unit position
- [`func bind_ammo_system(ammo_sys: AmmoSystem) -> void`](EngineerController/functions/bind_ammo_system.md) — Bind external systems
- [`func is_engineer_unit(unit_id: String) -> bool`](EngineerController/functions/is_engineer_unit.md) — Check if a unit is engineer-capable
- [`func get_available_engineer_ammo(unit_id: String) -> Array[String]`](EngineerController/functions/get_available_engineer_ammo.md) — Get available engineer ammunition types for a unit
- [`func request_task(unit_id: String, task_type: String, target_pos: Vector2) -> bool`](EngineerController/functions/request_task.md) — Request an engineer task
- [`func tick(delta: float) -> void`](EngineerController/functions/tick.md) — Tick active engineer tasks
- [`func _process_completion(task: EngineerTask) -> void`](EngineerController/functions/_process_completion.md) — Process task completion
`tasl` Engineer Task.
- [`func _place_bridge(target_pos: Vector2) -> void`](EngineerController/functions/_place_bridge.md) — Place a bridge at the target position
- [`func _find_nearest_water(pos: Vector2) -> Variant`](EngineerController/functions/_find_nearest_water.md) — Find the nearest water feature to a position (checks both surfaces and lines)
- [`func _is_water_feature(feature: Dictionary) -> bool`](EngineerController/functions/_is_water_feature.md) — Check if a terrain feature is water-related
- [`func _calculate_center(points: PackedVector2Array) -> Vector2`](EngineerController/functions/_calculate_center.md) — Calculate center point of a polygon or line
- [`func _calculate_bridge_span(water_surface: Dictionary, target_pos: Vector2) -> PackedVector2Array`](EngineerController/functions/_calculate_bridge_span.md) — Calculate optimal bridge span across water
- [`func _place_mines(_target_pos: Vector2) -> void`](EngineerController/functions/_place_mines.md) — Place mines at the target position (stub)
- [`func _place_demo(_target_pos: Vector2) -> void`](EngineerController/functions/_place_demo.md) — Place demo charges at the target position (stub)
- [`func _rebuild_pathfinding() -> void`](EngineerController/functions/_rebuild_pathfinding.md) — Rebuild pathfinding grid after terrain modification
- [`func _is_engineer_unit(u: UnitData) -> bool`](EngineerController/functions/_is_engineer_unit.md) — Check if unit has engineer ammunition
- [`func _init(p_unit_id: String, p_task_type: String, p_target_pos: Vector2, p_duration: float)`](EngineerController/functions/_init.md)

## Public Attributes

- `float mine_duration` — Time to lay mines (seconds)
- `float demo_duration` — Time to place demo charges (seconds)
- `float bridge_duration` — Time to build a bridge (seconds)
- `float required_proximity_m` — Required proximity to target position before task can start (meters)
- `TerrainRender terrain_renderer` — TerrainRender reference.
- `Dictionary _units`
- `Dictionary _positions`
- `Dictionary _engineer_units`
- `Array[EngineerTask] _active_tasks`
- `AmmoSystem _ammo_system`
- `String unit_id`
- `String task_type`
- `Vector2 target_pos`
- `float duration`
- `float time_elapsed`
- `bool started`

## Signals

- `signal task_confirmed(unit_id: String, task_type: String, target_pos: Vector2)` — Emitted when an engineer task is confirmed/accepted
- `signal task_started(unit_id: String, task_type: String, target_pos: Vector2)` — Emitted when task work begins
- `signal task_completed(unit_id: String, task_type: String, target_pos: Vector2)` — Emitted when task is completed

## Enumerations

- `enum TaskType` — Engineer task types

## Member Function Documentation

### _ready

```gdscript
func _ready() -> void
```

### register_unit

```gdscript
func register_unit(unit_id: String, u: UnitData) -> void
```

Register a unit and check if it's engineer-capable.
`unit_id` The ScenarioUnit ID (with SLOT suffix if applicable).
`u` The UnitData to register.

### unregister_unit

```gdscript
func unregister_unit(unit_id: String) -> void
```

Unregister a unit

### set_unit_position

```gdscript
func set_unit_position(unit_id: String, pos: Vector2) -> void
```

Update unit position

### bind_ammo_system

```gdscript
func bind_ammo_system(ammo_sys: AmmoSystem) -> void
```

Bind external systems

### is_engineer_unit

```gdscript
func is_engineer_unit(unit_id: String) -> bool
```

Check if a unit is engineer-capable

### get_available_engineer_ammo

```gdscript
func get_available_engineer_ammo(unit_id: String) -> Array[String]
```

Get available engineer ammunition types for a unit

### request_task

```gdscript
func request_task(unit_id: String, task_type: String, target_pos: Vector2) -> bool
```

Request an engineer task
Returns true if accepted, false if unable to comply

### tick

```gdscript
func tick(delta: float) -> void
```

Tick active engineer tasks

### _process_completion

```gdscript
func _process_completion(task: EngineerTask) -> void
```

Process task completion
`tasl` Engineer Task.

### _place_bridge

```gdscript
func _place_bridge(target_pos: Vector2) -> void
```

Place a bridge at the target position

### _find_nearest_water

```gdscript
func _find_nearest_water(pos: Vector2) -> Variant
```

Find the nearest water feature to a position (checks both surfaces and lines)

### _is_water_feature

```gdscript
func _is_water_feature(feature: Dictionary) -> bool
```

Check if a terrain feature is water-related

### _calculate_center

```gdscript
func _calculate_center(points: PackedVector2Array) -> Vector2
```

Calculate center point of a polygon or line

### _calculate_bridge_span

```gdscript
func _calculate_bridge_span(water_surface: Dictionary, target_pos: Vector2) -> PackedVector2Array
```

Calculate optimal bridge span across water

### _place_mines

```gdscript
func _place_mines(_target_pos: Vector2) -> void
```

Place mines at the target position (stub)

### _place_demo

```gdscript
func _place_demo(_target_pos: Vector2) -> void
```

Place demo charges at the target position (stub)

### _rebuild_pathfinding

```gdscript
func _rebuild_pathfinding() -> void
```

Rebuild pathfinding grid after terrain modification

### _is_engineer_unit

```gdscript
func _is_engineer_unit(u: UnitData) -> bool
```

Check if unit has engineer ammunition

### _init

```gdscript
func _init(p_unit_id: String, p_task_type: String, p_target_pos: Vector2, p_duration: float)
```

## Member Data Documentation

### mine_duration

```gdscript
var mine_duration: float
```

Decorators: `@export`

Time to lay mines (seconds)

### demo_duration

```gdscript
var demo_duration: float
```

Decorators: `@export`

Time to place demo charges (seconds)

### bridge_duration

```gdscript
var bridge_duration: float
```

Decorators: `@export`

Time to build a bridge (seconds)

### required_proximity_m

```gdscript
var required_proximity_m: float
```

Decorators: `@export`

Required proximity to target position before task can start (meters)

### terrain_renderer

```gdscript
var terrain_renderer: TerrainRender
```

Decorators: `@export`

TerrainRender reference.

### _units

```gdscript
var _units: Dictionary
```

### _positions

```gdscript
var _positions: Dictionary
```

### _engineer_units

```gdscript
var _engineer_units: Dictionary
```

### _active_tasks

```gdscript
var _active_tasks: Array[EngineerTask]
```

### _ammo_system

```gdscript
var _ammo_system: AmmoSystem
```

### unit_id

```gdscript
var unit_id: String
```

### task_type

```gdscript
var task_type: String
```

### target_pos

```gdscript
var target_pos: Vector2
```

### duration

```gdscript
var duration: float
```

### time_elapsed

```gdscript
var time_elapsed: float
```

### started

```gdscript
var started: bool
```

## Signal Documentation

### task_confirmed

```gdscript
signal task_confirmed(unit_id: String, task_type: String, target_pos: Vector2)
```

Emitted when an engineer task is confirmed/accepted

### task_started

```gdscript
signal task_started(unit_id: String, task_type: String, target_pos: Vector2)
```

Emitted when task work begins

### task_completed

```gdscript
signal task_completed(unit_id: String, task_type: String, target_pos: Vector2)
```

Emitted when task is completed

## Enumeration Type Documentation

### TaskType

```gdscript
enum TaskType
```

Engineer task types
