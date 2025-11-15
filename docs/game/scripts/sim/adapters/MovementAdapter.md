# MovementAdapter Class Reference

*File:* `scripts/sim/adapters/MovementAdapter.gd`
*Class name:* `MovementAdapter`
*Inherits:* `Node`
> **Experimental**

## Synopsis

```gdscript
class_name MovementAdapter
extends Node
```

## Brief

Movement adapter for pathfinding-based unit orders.

## Detailed Description

@brief Plans and ticks movement using per-unit profiles (FOOT/WHEELED/
TRACKED/RIVERINE), groups ticks by profile for performance, and resolves
map label names into terrain positions for destination orders.

Map lowercase mobility tags/strings to movement profiles.

Enable resolving String destinations using TerrainData.labels[].text.

## Public Member Functions

- [`func _ready() -> void`](MovementAdapter/functions/_ready.md) — Initialize grid hooks and build the label index.
- [`func _physics_process(dt: float) -> void`](MovementAdapter/functions/_physics_process.md)
- [`func _refresh_label_index() -> void`](MovementAdapter/functions/_refresh_label_index.md) — Rebuilds the label lookup from TerrainData.labels.
- [`func _norm_label(s: String) -> String`](MovementAdapter/functions/_norm_label.md) — Normalizes label text for tolerant matching.
- [`func _resolve_label_to_pos(label_text: String, origin_m: Vector2 = Vector2.INF) -> Variant`](MovementAdapter/functions/_resolve_label_to_pos.md) — Resolves a label phrase to a terrain position in meters.
- [`func plan_and_start_to_label(su: ScenarioUnit, label_text: String) -> bool`](MovementAdapter/functions/plan_and_start_to_label.md) — Plans and starts movement to a map label.
- [`func plan_and_start_any(su: ScenarioUnit, dest: Variant) -> bool`](MovementAdapter/functions/plan_and_start_any.md) — Plans and starts movement to either a Vector2 destination or a label.
- [`func _prebuild_needed_profiles(units: Array[ScenarioUnit]) -> void`](MovementAdapter/functions/_prebuild_needed_profiles.md) — Ensures PathGrid profiles needed by `units` are available.
- [`func tick_units(units: Array[ScenarioUnit], dt: float) -> void`](MovementAdapter/functions/tick_units.md) — Ticks unit movement grouped by profile (reduces grid switching).
- [`func cancel_move(su: ScenarioUnit) -> void`](MovementAdapter/functions/cancel_move.md) — Pauses current movement for a unit.
- [`func plan_and_start(su: ScenarioUnit, dest_m: Vector2) -> bool`](MovementAdapter/functions/plan_and_start.md) — Plans and immediately starts movement to `dest_m`.
- [`func plan_and_start_direct(su: ScenarioUnit, dest_m: Vector2) -> bool`](MovementAdapter/functions/plan_and_start_direct.md) — Plans and starts direct straight-line movement without pathfinding.
- [`func _on_grid_ready(profile: int) -> void`](MovementAdapter/functions/_on_grid_ready.md) — Starts any deferred moves whose profile just finished building.
- [`func set_behaviour_params(speed_mult: float, _cover_bias_unused: float, noise_level: float) -> void`](MovementAdapter/functions/set_behaviour_params.md) — Behaviour mapping from AIAgent
- [`func request_move_to(dest: Vector3) -> void`](MovementAdapter/functions/request_move_to.md) — TaskMove
- [`func is_move_complete() -> bool`](MovementAdapter/functions/is_move_complete.md)
- [`func request_hold_area(center: Vector3, radius: float) -> void`](MovementAdapter/functions/request_hold_area.md) — TaskDefend
- [`func is_hold_established() -> bool`](MovementAdapter/functions/is_hold_established.md)
- [`func request_patrol(points: Array[Vector3], ping_pong: bool, loop_forever: bool = false) -> void`](MovementAdapter/functions/request_patrol.md) — TaskPatrol
- [`func is_patrol_running() -> bool`](MovementAdapter/functions/is_patrol_running.md)
- [`func set_patrol_dwell(seconds: float) -> void`](MovementAdapter/functions/set_patrol_dwell.md) — Optional setter to customize dwell time between patrol legs
- [`func _step_move(dt: float) -> void`](MovementAdapter/functions/_step_move.md)
- [`func _tick_hold(dt: float) -> void`](MovementAdapter/functions/_tick_hold.md)
- [`func _tick_patrol(dt: float) -> void`](MovementAdapter/functions/_tick_patrol.md)
- [`func _advance_patrol_leg() -> bool`](MovementAdapter/functions/_advance_patrol_leg.md)

## Public Attributes

- `TerrainRender renderer` — Terrain renderer providing the PathGrid and TerrainData.
- `int default_profile` — Default profile used when a unit has no explicit movement profile.
- `NodePath actor_path` — AI Agent Related Variables
The Node3D that actually moves (usually the unit root).
- `float base_speed_mps` — Base speed before behaviour multipliers (meters per second).
- `float arrive_epsilon` — Stop when closer than this distance to a target.
- `bool rotate_to_velocity` — Rotate actor to face velocity during movement.
- `float hold_settle_time` — Time that must elapse after arriving in a hold area to consider it established.
- `float patrol_dwell_seconds` — Dwell time on each patrol point before advancing.
- `Node3D _actor`
- `float _speed_mult`
- `float _noise_level`
- `bool _moving`
- `Vector3 _move_target`
- `bool _holding`
- `Vector3 _hold_center`
- `float _hold_radius`
- `float _hold_timer`
- `bool _patrol_running`
- `Array[Vector3] _patrol_points`
- `bool _patrol_ping_pong`
- `int _patrol_index`
- `bool _patrol_forward`
- `int _patrol_segments_remaining`
- `float _patrol_dwell`
- `bool _patrol_loop_forever`
- `PathGrid _grid`
- `Dictionary _labels`

## Member Function Documentation

### _ready

```gdscript
func _ready() -> void
```

Initialize grid hooks and build the label index.

### _physics_process

```gdscript
func _physics_process(dt: float) -> void
```

### _refresh_label_index

```gdscript
func _refresh_label_index() -> void
```

Rebuilds the label lookup from TerrainData.labels.
Stores: normalized_text -> Array[Vector2] (terrain meters).

### _norm_label

```gdscript
func _norm_label(s: String) -> String
```

Normalizes label text for tolerant matching.
Removes punctuation, collapses spaces, and lowercases.
`s` Original label text.
[return] Normalized key.

### _resolve_label_to_pos

```gdscript
func _resolve_label_to_pos(label_text: String, origin_m: Vector2 = Vector2.INF) -> Variant
```

Resolves a label phrase to a terrain position in meters.
When multiple labels share the same text, picks the closest to origin.
`label_text` Label string to look up.
`origin_m` Optional origin (unit position) for tie-breaking.
[return] Vector2 position if found, otherwise null.

### plan_and_start_to_label

```gdscript
func plan_and_start_to_label(su: ScenarioUnit, label_text: String) -> bool
```

Plans and starts movement to a map label.
`su` ScenarioUnit to move.
`label_text` Label name to resolve.
[return] True if the order was accepted (or deferred), else false.

### plan_and_start_any

```gdscript
func plan_and_start_any(su: ScenarioUnit, dest: Variant) -> bool
```

Plans and starts movement to either a Vector2 destination or a label.
Also accepts {x,y} or {pos: Vector2} dictionaries.
`su` ScenarioUnit to move.
`dest` Vector2 | String | Dictionary destination.
[return] True if the order was accepted (or deferred), else false.

### _prebuild_needed_profiles

```gdscript
func _prebuild_needed_profiles(units: Array[ScenarioUnit]) -> void
```

Ensures PathGrid profiles needed by `units` are available.
Triggers async builds for any missing profiles.

### tick_units

```gdscript
func tick_units(units: Array[ScenarioUnit], dt: float) -> void
```

Ticks unit movement grouped by profile (reduces grid switching).
Skips groups whose profile grid is still building this frame.
`units` Units to tick.
`dt` Delta time in seconds.

### cancel_move

```gdscript
func cancel_move(su: ScenarioUnit) -> void
```

Pauses current movement for a unit.
`su` ScenarioUnit to pause.

### plan_and_start

```gdscript
func plan_and_start(su: ScenarioUnit, dest_m: Vector2) -> bool
```

Plans and immediately starts movement to `dest_m`.
Defers start if the profile grid is still building.
`su` ScenarioUnit to move.
`dest_m` Destination in terrain meters.
[return] True if planned (or deferred), false on error or plan failure.

### plan_and_start_direct

```gdscript
func plan_and_start_direct(su: ScenarioUnit, dest_m: Vector2) -> bool
```

Plans and starts direct straight-line movement without pathfinding.
Defers start if the profile grid is still building.
`su` ScenarioUnit to move.
`dest_m` Destination in terrain meters.
[return] True if planned (or deferred), false on error.

### _on_grid_ready

```gdscript
func _on_grid_ready(profile: int) -> void
```

Starts any deferred moves whose profile just finished building.
`profile` Movement profile that became available.

### set_behaviour_params

```gdscript
func set_behaviour_params(speed_mult: float, _cover_bias_unused: float, noise_level: float) -> void
```

Behaviour mapping from AIAgent

### request_move_to

```gdscript
func request_move_to(dest: Vector3) -> void
```

TaskMove

### is_move_complete

```gdscript
func is_move_complete() -> bool
```

### request_hold_area

```gdscript
func request_hold_area(center: Vector3, radius: float) -> void
```

TaskDefend

### is_hold_established

```gdscript
func is_hold_established() -> bool
```

### request_patrol

```gdscript
func request_patrol(points: Array[Vector3], ping_pong: bool, loop_forever: bool = false) -> void
```

TaskPatrol

### is_patrol_running

```gdscript
func is_patrol_running() -> bool
```

### set_patrol_dwell

```gdscript
func set_patrol_dwell(seconds: float) -> void
```

Optional setter to customize dwell time between patrol legs

### _step_move

```gdscript
func _step_move(dt: float) -> void
```

### _tick_hold

```gdscript
func _tick_hold(dt: float) -> void
```

### _tick_patrol

```gdscript
func _tick_patrol(dt: float) -> void
```

### _advance_patrol_leg

```gdscript
func _advance_patrol_leg() -> bool
```

## Member Data Documentation

### renderer

```gdscript
var renderer: TerrainRender
```

Decorators: `@export`

Terrain renderer providing the PathGrid and TerrainData.

### default_profile

```gdscript
var default_profile: int
```

Decorators: `@export`

Default profile used when a unit has no explicit movement profile.

### actor_path

```gdscript
var actor_path: NodePath
```

Decorators: `@export`

AI Agent Related Variables
The Node3D that actually moves (usually the unit root).

### base_speed_mps

```gdscript
var base_speed_mps: float
```

Decorators: `@export`

Base speed before behaviour multipliers (meters per second).

### arrive_epsilon

```gdscript
var arrive_epsilon: float
```

Decorators: `@export`

Stop when closer than this distance to a target.

### rotate_to_velocity

```gdscript
var rotate_to_velocity: bool
```

Decorators: `@export`

Rotate actor to face velocity during movement.

### hold_settle_time

```gdscript
var hold_settle_time: float
```

Decorators: `@export`

Time that must elapse after arriving in a hold area to consider it established.

### patrol_dwell_seconds

```gdscript
var patrol_dwell_seconds: float
```

Decorators: `@export`

Dwell time on each patrol point before advancing.

### _actor

```gdscript
var _actor: Node3D
```

### _speed_mult

```gdscript
var _speed_mult: float
```

### _noise_level

```gdscript
var _noise_level: float
```

### _moving

```gdscript
var _moving: bool
```

### _move_target

```gdscript
var _move_target: Vector3
```

### _holding

```gdscript
var _holding: bool
```

### _hold_center

```gdscript
var _hold_center: Vector3
```

### _hold_radius

```gdscript
var _hold_radius: float
```

### _hold_timer

```gdscript
var _hold_timer: float
```

### _patrol_running

```gdscript
var _patrol_running: bool
```

### _patrol_points

```gdscript
var _patrol_points: Array[Vector3]
```

### _patrol_ping_pong

```gdscript
var _patrol_ping_pong: bool
```

### _patrol_index

```gdscript
var _patrol_index: int
```

### _patrol_forward

```gdscript
var _patrol_forward: bool
```

### _patrol_segments_remaining

```gdscript
var _patrol_segments_remaining: int
```

### _patrol_dwell

```gdscript
var _patrol_dwell: float
```

### _patrol_loop_forever

```gdscript
var _patrol_loop_forever: bool
```

### _grid

```gdscript
var _grid: PathGrid
```

### _labels

```gdscript
var _labels: Dictionary
```
