# TriggerAPI Class Reference

*File:* `scripts/sim/scenario/TriggerAPI.gd`
*Class name:* `TriggerAPI`
*Inherits:* `RefCounted`

## Synopsis

```gdscript
class_name TriggerAPI
extends RefCounted
```

## Brief

Count units in an area by affiliation: "friend"|"enemy"|"player"|"any".

## Detailed Description

`affiliation` Unit affiliation.
`center_m` Center of area.
`size_m` Size of area.
`shape` Shape of area (default "rect").
[return] Amount of filtered units in area as int.

Return an Array of unit snapshots in an area.
`affiliation` Unit affiliation.
`center_m` Center of area.
`size_m` Size of area.
`shape` Shape of area (default "rect").
[return] Array of filtered units in area

## Public Member Functions

- [`func time_s() -> float`](TriggerAPI/functions/time_s.md) — Return mission time in seconds.
- [`func radio(msg: String, level: String = "info") -> void`](TriggerAPI/functions/radio.md) — Send a radio/log message (levels: info|warn|error).
- [`func complete_objective(id: StringName) -> void`](TriggerAPI/functions/complete_objective.md) — Set objective state to completed.
- [`func fail_objective(id: StringName) -> void`](TriggerAPI/functions/fail_objective.md) — Set objective state to failed.
- [`func set_objective(id: StringName, state: int) -> void`](TriggerAPI/functions/set_objective.md) — Set objective state
`id` Objective ID.
- [`func objective_state(id: StringName) -> int`](TriggerAPI/functions/objective_state.md) — Get current objective state via summary payload.
- [`func unit(id_or_callsign: String) -> Dictionary`](TriggerAPI/functions/unit.md) — Minimal snapshot of a unit by id or callsign.

## Public Attributes

- `SimWorld sim` — Whitelisted helper API for trigger scripts.
- `TriggerEngine engine`

## Member Function Documentation

### time_s

```gdscript
func time_s() -> float
```

Return mission time in seconds.
[return] Mission time in seconds.

### radio

```gdscript
func radio(msg: String, level: String = "info") -> void
```

Send a radio/log message (levels: info|warn|error).
`msg` Radio message.
`level` Optional Log level.

### complete_objective

```gdscript
func complete_objective(id: StringName) -> void
```

Set objective state to completed.
`id` Objective ID.

### fail_objective

```gdscript
func fail_objective(id: StringName) -> void
```

Set objective state to failed.
`id` Objective ID.

### set_objective

```gdscript
func set_objective(id: StringName, state: int) -> void
```

Set objective state
`id` Objective ID.
`state` ObjectiveState enum.

### objective_state

```gdscript
func objective_state(id: StringName) -> int
```

Get current objective state via summary payload.
`id` Objective ID.
[return] Current objective state as int.

### unit

```gdscript
func unit(id_or_callsign: String) -> Dictionary
```

Minimal snapshot of a unit by id or callsign.
`id_or_callsign` Unit ID or Unit Callsign.
[return] {id, callsign, pos_m: Vector2, aff: int} or {}.

## Member Data Documentation

### sim

```gdscript
var sim: SimWorld
```

Whitelisted helper API for trigger scripts.
Methods are available inside condition/on_activate/on_deactivate expressions.

### engine

```gdscript
var engine: TriggerEngine
```
