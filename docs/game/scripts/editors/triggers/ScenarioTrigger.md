# ScenarioTrigger Class Reference

*File:* `scripts/editors/triggers/ScenarioTrigger.gd`
*Class name:* `ScenarioTrigger`
*Inherits:* `Resource`

## Synopsis

```gdscript
class_name ScenarioTrigger
extends Resource
```

## Brief

Generic, scriptable trigger with optional area/presence and timer.

## Detailed Description

Evaluates each frame. runs on_activate/on_deactivate when switching state.

Presence mode

## Public Member Functions

- [`func serialize() -> Dictionary`](ScenarioTrigger/functions/serialize.md)
- [`func deserialize(d: Variant) -> ScenarioTrigger`](ScenarioTrigger/functions/deserialize.md)

## Public Attributes

- `String id` — Unique identifier of the trigger
- `String title` — Trigger title
- `Texture2D icon` — Trigger icon
- `AreaShape area_shape` — Area shape.
- `Vector2 area_center_m` — Center of area in *terrain meters*
- `Vector2 area_size_m` — Area size in meters (width, height)
- `PresenceMode presence` — Presence Mode
- `float require_duration_s` — Time (seconds) the combined condition must stay true before activation
- `bool run_once` — If true, trigger only fires once and then disables itself
- `String condition_expr` — Extra condition (must be true along with presence), evaluated every frame
- `String on_activate_expr` — Executed once on activation.
- `String on_deactivate_expr` — Executed once when condition becomes false after being active
- `Array[int] synced_units` — Synced editor units
- `Array[int] synced_tasks` — Synced editor tasks
- `bool _active`
- `float _accum_true`
- `bool _has_run`

## Enumerations

- `enum AreaShape` — Area Shape type

## Member Function Documentation

### serialize

```gdscript
func serialize() -> Dictionary
```

### deserialize

```gdscript
func deserialize(d: Variant) -> ScenarioTrigger
```

## Member Data Documentation

### id

```gdscript
var id: String
```

Decorators: `@export`

Unique identifier of the trigger

### title

```gdscript
var title: String
```

Decorators: `@export`

Trigger title

### icon

```gdscript
var icon: Texture2D
```

Decorators: `@export`

Trigger icon

### area_shape

```gdscript
var area_shape: AreaShape
```

Decorators: `@export`

Area shape.

### area_center_m

```gdscript
var area_center_m: Vector2
```

Decorators: `@export`

Center of area in *terrain meters*

### area_size_m

```gdscript
var area_size_m: Vector2
```

Decorators: `@export`

Area size in meters (width, height)

### presence

```gdscript
var presence: PresenceMode
```

Decorators: `@export`

Presence Mode

### require_duration_s

```gdscript
var require_duration_s: float
```

Decorators: `@export`

Time (seconds) the combined condition must stay true before activation

### run_once

```gdscript
var run_once: bool
```

Decorators: `@export`

If true, trigger only fires once and then disables itself

### condition_expr

```gdscript
var condition_expr: String
```

Decorators: `@export_multiline`

Extra condition (must be true along with presence), evaluated every frame

### on_activate_expr

```gdscript
var on_activate_expr: String
```

Decorators: `@export_multiline`

Executed once on activation. Same variable scope as condition

### on_deactivate_expr

```gdscript
var on_deactivate_expr: String
```

Decorators: `@export_multiline`

Executed once when condition becomes false after being active

### synced_units

```gdscript
var synced_units: Array[int]
```

Decorators: `@export`

Synced editor units

### synced_tasks

```gdscript
var synced_tasks: Array[int]
```

Decorators: `@export`

Synced editor tasks

### _active

```gdscript
var _active: bool
```

### _accum_true

```gdscript
var _accum_true: float
```

### _has_run

```gdscript
var _has_run: bool
```

## Enumeration Type Documentation

### AreaShape

```gdscript
enum AreaShape
```

Area Shape type
