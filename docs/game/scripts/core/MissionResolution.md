# MissionResolution Class Reference

*File:* `scripts/core/MissionResolution.gd`
*Class name:* `MissionResolution`
*Inherits:* `Node`

## Synopsis

```gdscript
class_name MissionResolution
extends Node
```

## Brief

Scoring weights

## Public Member Functions

- [`func start(prim: Array[StringName], scenario: StringName = &"") -> void`](MissionResolution/functions/start.md) — Initialize for a mission.
- [`func tick(dt: float) -> void`](MissionResolution/functions/tick.md) — Advance internal timer.
- [`func set_objective_state(id: StringName, state: ObjectiveState) -> void`](MissionResolution/functions/set_objective_state.md) — Update an objective state.
- [`func add_casualties(friendly: int = 0, enemy: int = 0) -> void`](MissionResolution/functions/add_casualties.md) — Record casualties (aggregated).
- [`func add_units_lost(count: int = 1) -> void`](MissionResolution/functions/add_units_lost.md) — Record fully destroyed friendly unit(s) (e.g., wiped marker).
- [`func evaluate_outcome() -> MissionOutcome`](MissionResolution/functions/evaluate_outcome.md) — Compute current best-guess outcome (not final).
- [`func finalize(abort: bool = false) -> Dictionary`](MissionResolution/functions/finalize.md) — Finalize the mission (moves to immutable state).
- [`func to_summary_payload() -> Dictionary`](MissionResolution/functions/to_summary_payload.md) — Debrief/persistence payload; stable contract for other screens.
- [`func _reset() -> void`](MissionResolution/functions/_reset.md) — Clear all state.
- [`func _recompute_score() -> void`](MissionResolution/functions/_recompute_score.md)
- [`func _score_breakdown() -> Dictionary`](MissionResolution/functions/_score_breakdown.md)

## Public Attributes

- `StringName scenario_id`
- `Array[StringName] primary_objectives`
- `Dictionary _objective_states`
- `int _units_lost`
- `float _elapsed_s`
- `int _total_score`
- `MissionOutcome _outcome`
- `bool _is_final`

## Signals

- `signal objective_updated(objective_id: StringName, state: ObjectiveState)` — Tracks mission progress and computes a placeholder outcome + score. **Experimental**
- `signal score_changed(total: int)`
- `signal mission_finalized(outcome: MissionOutcome, summary: Dictionary)`

## Enumerations

- `enum ObjectiveState` — Logical Objective states
- `enum MissionOutcome` — Logical Mission Outcome states

## Member Function Documentation

### start

```gdscript
func start(prim: Array[StringName], scenario: StringName = &"") -> void
```

Initialize for a mission.

### tick

```gdscript
func tick(dt: float) -> void
```

Advance internal timer. Call from mission loop.

### set_objective_state

```gdscript
func set_objective_state(id: StringName, state: ObjectiveState) -> void
```

Update an objective state.

### add_casualties

```gdscript
func add_casualties(friendly: int = 0, enemy: int = 0) -> void
```

Record casualties (aggregated).

### add_units_lost

```gdscript
func add_units_lost(count: int = 1) -> void
```

Record fully destroyed friendly unit(s) (e.g., wiped marker).

### evaluate_outcome

```gdscript
func evaluate_outcome() -> MissionOutcome
```

Compute current best-guess outcome (not final).

### finalize

```gdscript
func finalize(abort: bool = false) -> Dictionary
```

Finalize the mission (moves to immutable state).

### to_summary_payload

```gdscript
func to_summary_payload() -> Dictionary
```

Debrief/persistence payload; stable contract for other screens.

### _reset

```gdscript
func _reset() -> void
```

Clear all state.

### _recompute_score

```gdscript
func _recompute_score() -> void
```

### _score_breakdown

```gdscript
func _score_breakdown() -> Dictionary
```

## Member Data Documentation

### scenario_id

```gdscript
var scenario_id: StringName
```

### primary_objectives

```gdscript
var primary_objectives: Array[StringName]
```

### _objective_states

```gdscript
var _objective_states: Dictionary
```

### _units_lost

```gdscript
var _units_lost: int
```

### _elapsed_s

```gdscript
var _elapsed_s: float
```

### _total_score

```gdscript
var _total_score: int
```

### _outcome

```gdscript
var _outcome: MissionOutcome
```

### _is_final

```gdscript
var _is_final: bool
```

## Signal Documentation

### objective_updated

```gdscript
signal objective_updated(objective_id: StringName, state: ObjectiveState)
```

> **Experimental**

Tracks mission progress and computes a placeholder outcome + score.
Use as a helper owned by your Game singleton / mission scene.

### score_changed

```gdscript
signal score_changed(total: int)
```

### mission_finalized

```gdscript
signal mission_finalized(outcome: MissionOutcome, summary: Dictionary)
```

## Enumeration Type Documentation

### ObjectiveState

```gdscript
enum ObjectiveState
```

Logical Objective states

### MissionOutcome

```gdscript
enum MissionOutcome
```

Logical Mission Outcome states
