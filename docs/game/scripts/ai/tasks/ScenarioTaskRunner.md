# ScenarioTaskRunner Class Reference

*File:* `scripts/ai/tasks/ScenarioTaskRunner.gd`
*Class name:* `ScenarioTaskRunner`
*Inherits:* `Node`

## Synopsis

```gdscript
class_name ScenarioTaskRunner
extends Node
```

## Brief

Runs a deterministic chain of authored tasks for one unit and emits lifecycle events.

## Detailed Description

Expected task dictionaries:
{ "type": "TaskMove", "point_m": Vector2 }
{ "type": "TaskDefend", "center_m": Vector2, "radius": 25.0 }
{ "type": "TaskPatrol", "points_m": Array[Vector2], "ping_pong": bool }
{ "type": "TaskSetBehaviour", "behaviour": int }
{ "type": "TaskSetCombatMode", "mode": int }
{ "type": "TaskWait", "seconds": float, "until_contact": bool }

## Public Member Functions

- [`func setup(p_unit_id: int, ordered_tasks: Array[Dictionary]) -> void`](ScenarioTaskRunner/functions/setup.md) — Initialize this runner for a unit and its ordered task list.
- [`func is_idle() -> bool`](ScenarioTaskRunner/functions/is_idle.md) — True when there is no active task and the queue is empty.
- [`func pause() -> void`](ScenarioTaskRunner/functions/pause.md) — Pause task processing (current task remains active).
- [`func resume() -> void`](ScenarioTaskRunner/functions/resume.md) — Resume task processing after a pause().
- [`func cancel_active() -> void`](ScenarioTaskRunner/functions/cancel_active.md) — Cancel the active task; the next tick will start the next queued task.
- [`func advance() -> void`](ScenarioTaskRunner/functions/advance.md) — Force-skip the active task and begin the next one.
- [`func _start_next() -> bool`](ScenarioTaskRunner/functions/_start_next.md) — Pop the next task (if unblocked) and emit task_started.
- [`func tick(dt: float, agent: AIAgent) -> void`](ScenarioTaskRunner/functions/tick.md) — Advance the active task using the supplied AIAgent.
- [`func block_task_index(idx: int, blocked: bool) -> void`](ScenarioTaskRunner/functions/block_task_index.md) — Block or unblock tasks by their scenario source index.

## Public Attributes

- `int unit_id` — Unit index in ScenarioData.units that this runner controls.
- `Array[Dictionary] _queue` — Pending tasks for this unit (FIFO order).
- `Dictionary _active` — Currently executing task dictionary.
- `bool _paused` — If true, tick() is ignored until resume() is called.
- `bool _started_current` — Internal flag to issue begin/intents only once per task.
- `Dictionary _tasks_by_index` — Lookup: scenario task index -> array of queue entries.

## Signals

- `signal task_started(unit_id: int, task_type: StringName)` — Emitted when a task becomes active for this unit.
- `signal task_completed(unit_id: int, task_type: StringName)` — Emitted when the active task completes successfully.
- `signal task_failed(unit_id: int, task_type: StringName, reason: StringName)` — Emitted when a task cannot be executed (unknown/malformed).

## Member Function Documentation

### setup

```gdscript
func setup(p_unit_id: int, ordered_tasks: Array[Dictionary]) -> void
```

Initialize this runner for a unit and its ordered task list.
`p_unit_id` Unit index in ScenarioData.units.
`ordered_tasks` Runner-ready tasks in execution order.

### is_idle

```gdscript
func is_idle() -> bool
```

True when there is no active task and the queue is empty.

### pause

```gdscript
func pause() -> void
```

Pause task processing (current task remains active).

### resume

```gdscript
func resume() -> void
```

Resume task processing after a pause().

### cancel_active

```gdscript
func cancel_active() -> void
```

Cancel the active task; the next tick will start the next queued task.

### advance

```gdscript
func advance() -> void
```

Force-skip the active task and begin the next one.

### _start_next

```gdscript
func _start_next() -> bool
```

Pop the next task (if unblocked) and emit task_started.
[return] True if a task was started.

### tick

```gdscript
func tick(dt: float, agent: AIAgent) -> void
```

Advance the active task using the supplied AIAgent.
`dt` Delta time (seconds).
`agent` AIAgent that performs intents and completion checks.

### block_task_index

```gdscript
func block_task_index(idx: int, blocked: bool) -> void
```

Block or unblock tasks by their scenario source index.

## Member Data Documentation

### unit_id

```gdscript
var unit_id: int
```

Unit index in ScenarioData.units that this runner controls.

### _queue

```gdscript
var _queue: Array[Dictionary]
```

Pending tasks for this unit (FIFO order).

### _active

```gdscript
var _active: Dictionary
```

Currently executing task dictionary.

### _paused

```gdscript
var _paused: bool
```

If true, tick() is ignored until resume() is called.

### _started_current

```gdscript
var _started_current: bool
```

Internal flag to issue begin/intents only once per task.

### _tasks_by_index

```gdscript
var _tasks_by_index: Dictionary
```

Lookup: scenario task index -> array of queue entries.

## Signal Documentation

### task_started

```gdscript
signal task_started(unit_id: int, task_type: StringName)
```

Emitted when a task becomes active for this unit.

### task_completed

```gdscript
signal task_completed(unit_id: int, task_type: StringName)
```

Emitted when the active task completes successfully.

### task_failed

```gdscript
signal task_failed(unit_id: int, task_type: StringName, reason: StringName)
```

Emitted when a task cannot be executed (unknown/malformed).
