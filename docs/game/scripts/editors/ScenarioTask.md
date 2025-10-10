# ScenarioTask Class Reference

*File:* `scripts/editors/ScenarioTask.gd`
*Class name:* `ScenarioTask`
*Inherits:* `Resource`

## Synopsis

```gdscript
class_name ScenarioTask
extends Resource
```

## Brief

A placed task for a unit with per-instance params and linking

## Detailed Description

Where to find task scripts

## Public Member Functions

- [`func serialize() -> Dictionary`](ScenarioTask/functions/serialize.md) — Convert this task into a JSON-safe dictionary
- [`func deserialize(d: Dictionary) -> ScenarioTask`](ScenarioTask/functions/deserialize.md) — Create/restore from a JSON dictionary
- [`func _ensure_task_index() -> void`](ScenarioTask/functions/_ensure_task_index.md) — Build/refresh the type_id -> Script index
- [`func _make_task_from_type_id(type_id: StringName) -> UnitBaseTask`](ScenarioTask/functions/_make_task_from_type_id.md) — Resolve and instance a UnitBaseTask by type_id (or null)

## Public Attributes

- `String id` — Unique Id within scenario
- `UnitBaseTask task` — The task definition
- `Vector2 position_m` — World position (meters)
- `Dictionary params` — Overrides per exported property of `task`
- `int unit_index` — Owner unit index in ScenarioData.units
- `int next_index` — Link to next ScenarioTask in the chain
- `int prev_index` — Link to previous ScenarioTask in the chain

## Member Function Documentation

### serialize

```gdscript
func serialize() -> Dictionary
```

Convert this task into a JSON-safe dictionary

### deserialize

```gdscript
func deserialize(d: Dictionary) -> ScenarioTask
```

Create/restore from a JSON dictionary

### _ensure_task_index

```gdscript
func _ensure_task_index() -> void
```

Build/refresh the type_id -> Script index

### _make_task_from_type_id

```gdscript
func _make_task_from_type_id(type_id: StringName) -> UnitBaseTask
```

Resolve and instance a UnitBaseTask by type_id (or null)

## Member Data Documentation

### id

```gdscript
var id: String
```

Decorators: `@export`

Unique Id within scenario

### task

```gdscript
var task: UnitBaseTask
```

Decorators: `@export`

The task definition

### position_m

```gdscript
var position_m: Vector2
```

Decorators: `@export`

World position (meters)

### params

```gdscript
var params: Dictionary
```

Decorators: `@export`

Overrides per exported property of `task`

### unit_index

```gdscript
var unit_index: int
```

Decorators: `@export`

Owner unit index in ScenarioData.units

### next_index

```gdscript
var next_index: int
```

Decorators: `@export`

Link to next ScenarioTask in the chain

### prev_index

```gdscript
var prev_index: int
```

Decorators: `@export`

Link to previous ScenarioTask in the chain
