# MovementAgent Class Reference

*File:* `scripts/ai/MovementAgent.gd`
*Class name:* `MovementAgent`
*Inherits:* `Node2D`

## Synopsis

```gdscript
class_name MovementAgent
extends Node2D
```

## Brief

Moves this node over PathGrid in world meters.

## Detailed Description

Uses base speed modified by PathGrid cell weight and terrain lines/areas.

Pathfinding grid (provide in inspector or at runtime).

If true, agent waits for grid build_ready before pathing.

Master switch for all debug drawing.

Show a small text HUD with speed/ETA/weight.

Outline the current and next grid cells.

Draw the planned path and waypoint markers.

Draw heading and per-frame velocity vectors.

Keep a breadcrumb trail of recent positions.

Radius (meters) for point markers.

## Public Member Functions

- [`func _ready() -> void`](MovementAgent/functions/_ready.md)
- [`func _physics_process(delta: float) -> void`](MovementAgent/functions/_physics_process.md)
- [`func _draw() -> void`](MovementAgent/functions/_draw.md)
- [`func _effective_speed_at(p_m: Vector2) -> float`](MovementAgent/functions/_effective_speed_at.md) — Function does also include the fuel system penalties for the AI
- [`func move_to_m(dest_m: Vector2) -> void`](MovementAgent/functions/move_to_m.md) — Command pathfind and start moving to a world-meter destination.
- [`func stop() -> void`](MovementAgent/functions/stop.md) — Command stop immediately.
- [`func eta_seconds() -> float`](MovementAgent/functions/eta_seconds.md) — ETA (seconds) along current remaining path with current base speed.
- [`func _set_path(p: PackedVector2Array) -> void`](MovementAgent/functions/_set_path.md)
- [`func _on_grid_ready(ready_profile: int) -> void`](MovementAgent/functions/_on_grid_ready.md)
- [`func _debug_push_trail() -> void`](MovementAgent/functions/_debug_push_trail.md) — Push current position into the breadcrumb list.
- [`func _debug_current_cell() -> Vector2i`](MovementAgent/functions/_debug_current_cell.md) — Get the agent's current cell (if grid exists).
- [`func _debug_cell_rect_world(c: Vector2i) -> Rect2`](MovementAgent/functions/_debug_cell_rect_world.md) — Get a Rect2 (in *world meters*) for a cell id.
- [`func _debug_weight_here() -> float`](MovementAgent/functions/_debug_weight_here.md) — Read current cell weight safely.
- [`func _debug_instant_speed(delta: float) -> float`](MovementAgent/functions/_debug_instant_speed.md) — Compute instantaneous speed (m/s) based on last trail step.
- [`func _draw_cell_rect_m(rm: Rect2, col: Color, width: float, filled := false) -> void`](MovementAgent/functions/_draw_cell_rect_m.md)
- [`func _to_local_from_terrain(p_m: Vector2) -> Vector2`](MovementAgent/functions/_to_local_from_terrain.md) — Convert terrain meters -> this node's local draw space

## Public Attributes

- `PathGrid grid`
- `TerrainBrush.MoveProfile profile` — Movement profile used for costs.
- `float base_speed_mps` — Base speed in meters/second (before terrain modifiers).
- `float arrival_threshold_m` — Distance to consider a waypoint reached (meters).
- `Vector2 sim_pos_m` — Virtual position in terrain meters
- `String unit_id` — link to FuelSystem for slowdown/stop.
- `TerrainRender renderer`
- `PackedVector2Array _path`
- `PackedVector2Array _trail`
- `FuelSystem _fuel`

## Signals

- `signal movement_started` — Emitted when the agent starts following a path.
- `signal movement_arrived` — Emitted when the agent arrives at its final waypoint.
- `signal movement_blocked(reason: String)` — Emitted if the agent cannot find a path or hits a blocked cell.
- `signal path_updated(path: PackedVector2Array)` — Emitted whenever a new path is set.

## Member Function Documentation

### _ready

```gdscript
func _ready() -> void
```

### _physics_process

```gdscript
func _physics_process(delta: float) -> void
```

### _draw

```gdscript
func _draw() -> void
```

### _effective_speed_at

```gdscript
func _effective_speed_at(p_m: Vector2) -> float
```

Function does also include the fuel system penalties for the AI

### move_to_m

```gdscript
func move_to_m(dest_m: Vector2) -> void
```

Command pathfind and start moving to a world-meter destination.

### stop

```gdscript
func stop() -> void
```

Command stop immediately.

### eta_seconds

```gdscript
func eta_seconds() -> float
```

ETA (seconds) along current remaining path with current base speed.

### _set_path

```gdscript
func _set_path(p: PackedVector2Array) -> void
```

### _on_grid_ready

```gdscript
func _on_grid_ready(ready_profile: int) -> void
```

### _debug_push_trail

```gdscript
func _debug_push_trail() -> void
```

Push current position into the breadcrumb list.

### _debug_current_cell

```gdscript
func _debug_current_cell() -> Vector2i
```

Get the agent's current cell (if grid exists).

### _debug_cell_rect_world

```gdscript
func _debug_cell_rect_world(c: Vector2i) -> Rect2
```

Get a Rect2 (in *world meters*) for a cell id.

### _debug_weight_here

```gdscript
func _debug_weight_here() -> float
```

Read current cell weight safely.

### _debug_instant_speed

```gdscript
func _debug_instant_speed(delta: float) -> float
```

Compute instantaneous speed (m/s) based on last trail step.

### _draw_cell_rect_m

```gdscript
func _draw_cell_rect_m(rm: Rect2, col: Color, width: float, filled := false) -> void
```

### _to_local_from_terrain

```gdscript
func _to_local_from_terrain(p_m: Vector2) -> Vector2
```

Convert terrain meters -> this node's local draw space

## Member Data Documentation

### grid

```gdscript
var grid: PathGrid
```

### profile

```gdscript
var profile: TerrainBrush.MoveProfile
```

Movement profile used for costs.

### base_speed_mps

```gdscript
var base_speed_mps: float
```

Base speed in meters/second (before terrain modifiers).

### arrival_threshold_m

```gdscript
var arrival_threshold_m: float
```

Distance to consider a waypoint reached (meters).

### sim_pos_m

```gdscript
var sim_pos_m: Vector2
```

Virtual position in terrain meters

### unit_id

```gdscript
var unit_id: String
```

link to FuelSystem for slowdown/stop.

### renderer

```gdscript
var renderer: TerrainRender
```

### _path

```gdscript
var _path: PackedVector2Array
```

### _trail

```gdscript
var _trail: PackedVector2Array
```

### _fuel

```gdscript
var _fuel: FuelSystem
```

## Signal Documentation

### movement_started

```gdscript
signal movement_started
```

Emitted when the agent starts following a path.

### movement_arrived

```gdscript
signal movement_arrived
```

Emitted when the agent arrives at its final waypoint.

### movement_blocked

```gdscript
signal movement_blocked(reason: String)
```

Emitted if the agent cannot find a path or hits a blocked cell.

### path_updated

```gdscript
signal path_updated(path: PackedVector2Array)
```

Emitted whenever a new path is set.
