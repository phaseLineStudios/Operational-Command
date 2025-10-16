# TriggerEngine Class Reference

*File:* `scripts/sim/scenario/TriggerEngine.gd`
*Class name:* `TriggerEngine`
*Inherits:* `Node`

## Synopsis

```gdscript
class_name TriggerEngine
extends Node
```

## Brief

Deterministic evaluator for ScenarioTrigger resources.

## Detailed Description

Combines presence checks with a sandboxed condition VM and executes actions.

If false, call tick(dt) manually from SimWorld

Count of units in area.
`center_m` Center of area
`size_m` Size of area.
`shape` Shape of area (rect or circle).
[return] a dictionary of unit counts.

Check if a given point is withn a shape.
`p` Point to check.
`center_m` Area center.
`size` Area size.
`shape` Area shape.
[return] True if point is inside shape.

Count of units in an area.
`affiliation` Affiliation to filter for.
`center_m` Center of area
`size_m` Size of area.
`shape` Shape of area (rect or circle).
[return] a dictionary of unit counts by affiliation.

Units in an area.
`affiliation` Affiliation to filter for.
`center_m` Center of area
`size_m` Size of area.
`shape` Shape of area (rect or circle).
[return] a dictionary of unit counts by affiliation.

## Public Member Functions

- [`func _ready() -> void`](TriggerEngine/functions/_ready.md) — Wire API.
- [`func _process(dt: float) -> void`](TriggerEngine/functions/_process.md) — Tick triggers independently.
- [`func bind_scenario(scenario: ScenarioData) -> void`](TriggerEngine/functions/bind_scenario.md) — Bind scenario to engine.
- [`func tick(dt: float) -> void`](TriggerEngine/functions/tick.md) — Deterministic evaluation entry point.
- [`func _refresh_unit_indices() -> void`](TriggerEngine/functions/_refresh_unit_indices.md) — Refresh unit indices.
- [`func _evaluate_trigger(t: ScenarioTrigger, dt: float) -> void`](TriggerEngine/functions/_evaluate_trigger.md) — Evaluate a ScenarioTrigger.
- [`func _check_presence(t: ScenarioTrigger) -> bool`](TriggerEngine/functions/_check_presence.md) — Check trigger unit presence.
- [`func _make_ctx(t: ScenarioTrigger, presence_ok: bool) -> Dictionary`](TriggerEngine/functions/_make_ctx.md) — Build a context to pass to trigger eval.
- [`func get_unit_snapshot(id_or_callsign: String) -> Dictionary`](TriggerEngine/functions/get_unit_snapshot.md) — Get a unit snapshot.

## Public Attributes

- `SimWorld _sim` — SimWorld for time and snapshots
- `ScenarioData _scenario`
- `Dictionary _snap_by_id`
- `Dictionary _id_by_callsign`
- `Dictionary s`
- `Vector2 pos`
- `float r`

## Member Function Documentation

### _ready

```gdscript
func _ready() -> void
```

Wire API.

### _process

```gdscript
func _process(dt: float) -> void
```

Tick triggers independently.

### bind_scenario

```gdscript
func bind_scenario(scenario: ScenarioData) -> void
```

Bind scenario to engine.
`scenario` Current scenario.

### tick

```gdscript
func tick(dt: float) -> void
```

Deterministic evaluation entry point.
`dt` delta time from last tick.

### _refresh_unit_indices

```gdscript
func _refresh_unit_indices() -> void
```

Refresh unit indices.

### _evaluate_trigger

```gdscript
func _evaluate_trigger(t: ScenarioTrigger, dt: float) -> void
```

Evaluate a ScenarioTrigger.
`t` Trigger to evaluate.
`dt` Delta time since last tick.

### _check_presence

```gdscript
func _check_presence(t: ScenarioTrigger) -> bool
```

Check trigger unit presence.
`t` Trigger to check unit presence on.
[return] True if presence passes.

### _make_ctx

```gdscript
func _make_ctx(t: ScenarioTrigger, presence_ok: bool) -> Dictionary
```

Build a context to pass to trigger eval.
`t` Trigger to create context for.
`presence_ok` Check if presence check is ok.
[return] trigger context.

### get_unit_snapshot

```gdscript
func get_unit_snapshot(id_or_callsign: String) -> Dictionary
```

Get a unit snapshot.
`id_or_callsign` ID or Callsign of unit.
[return] {id, callsign, pos_m: Vector2, aff: int} or {}.

## Member Data Documentation

### _sim

```gdscript
var _sim: SimWorld
```

Decorators: `@export`

SimWorld for time and snapshots

### _scenario

```gdscript
var _scenario: ScenarioData
```

### _snap_by_id

```gdscript
var _snap_by_id: Dictionary
```

### _id_by_callsign

```gdscript
var _id_by_callsign: Dictionary
```

### s

```gdscript
var s: Dictionary
```

### pos

```gdscript
var pos: Vector2
```

### r

```gdscript
var r: float
```
