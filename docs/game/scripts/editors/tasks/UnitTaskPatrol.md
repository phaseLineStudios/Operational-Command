# UnitTaskPatrol Class Reference

*File:* `scripts/editors/tasks/TaskPatrol.gd`
*Class name:* `UnitTaskPatrol`
*Inherits:* `UnitBaseTask`

## Synopsis

```gdscript
class_name UnitTaskPatrol
extends UnitBaseTask
```

## Public Member Functions

- [`func _init() -> void`](UnitTaskPatrol/functions/_init.md)

## Public Attributes

- `float radius_m` — Patrol within a radius around the point.
- `float dwell_s`
- `Vector2 edge`
- `Texture2D itex`

## Member Function Documentation

### _init

```gdscript
func _init() -> void
```

## Member Data Documentation

### radius_m

```gdscript
var radius_m: float
```

Decorators: `@export_range(10.0, 5000.0, 1.0)`

Patrol within a radius around the point.

### dwell_s

```gdscript
var dwell_s: float
```

### edge

```gdscript
var edge: Vector2
```

### itex

```gdscript
var itex: Texture2D
```
