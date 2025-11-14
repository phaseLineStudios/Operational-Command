class_name ScenarioTaskRunner
extends Node

## Runs a deterministic chain of authored tasks for one unit and emits lifecycle events.
##
## Expected task dictionaries:
##   { "type": "TaskMove", "point_m": Vector2 }
##   { "type": "TaskDefend", "center_m": Vector2, "radius": 25.0 }
##   { "type": "TaskPatrol", "points_m": Array[Vector2], "ping_pong": bool }
##   { "type": "TaskSetBehaviour", "behaviour": int }
##   { "type": "TaskSetCombatMode", "mode": int }
##   { "type": "TaskWait", "seconds": float, "until_contact": bool }

## Emitted when a task becomes active for this unit.
signal task_started(unit_id: int, task_type: StringName)
## Emitted when the active task completes successfully.
signal task_completed(unit_id: int, task_type: StringName)
## Emitted when a task cannot be executed (unknown/malformed).
signal task_failed(unit_id: int, task_type: StringName, reason: StringName)

## Unit index in ScenarioData.units that this runner controls.
var unit_id: int = -1
## Pending tasks for this unit (FIFO order).
var _queue: Array[Dictionary] = []
## Currently executing task dictionary.
var _active: Dictionary = {}
## If true, tick() is ignored until resume() is called.
var _paused: bool = false
## Internal flag to issue begin/intents only once per task.
var _started_current: bool = false
## Lookup: scenario task index -> array of queue entries.
var _tasks_by_index: Dictionary = {}


## Initialize this runner for a unit and its ordered task list.
## [param p_unit_id] Unit index in ScenarioData.units.
## [param ordered_tasks] Runner-ready tasks in execution order.
func setup(p_unit_id: int, ordered_tasks: Array[Dictionary]) -> void:
	unit_id = p_unit_id
	_queue = ordered_tasks.duplicate(true)
	_active = {}
	_paused = false
	_started_current = false
	_tasks_by_index.clear()
	for task in _queue:
		var idx := int(task.get("__src_index", -1))
		if idx < 0:
			continue
		if not _tasks_by_index.has(idx):
			_tasks_by_index[idx] = []
		(_tasks_by_index[idx] as Array).append(task)


## True when there is no active task and the queue is empty.
func is_idle() -> bool:
	return _active.is_empty() and _queue.is_empty()


## Pause task processing (current task remains active).
func pause() -> void:
	_paused = true


## Resume task processing after a pause().
func resume() -> void:
	_paused = false


## Cancel the active task; the next tick will start the next queued task.
func cancel_active() -> void:
	_active.clear()
	_started_current = false


## Force-skip the active task and begin the next one.
func advance() -> void:
	_active.clear()
	_started_current = false


## Pop the next task (if unblocked) and emit task_started.
## [return] True if a task was started.
func _start_next() -> bool:
	if _queue.is_empty():
		_active = {}
		_started_current = false
		return false
	var candidate: Dictionary = _queue[0]
	if bool(candidate.get("_blocked", false)):
		_active = {}
		_started_current = false
		return false
	_active = _queue.pop_front()
	_started_current = false
	emit_signal("task_started", unit_id, StringName(_active.get("type", "unknown")))
	return true


## Advance the active task using the supplied AIAgent.
## [param dt] Delta time (seconds).
## [param agent] AIAgent that performs intents and completion checks.
func tick(dt: float, agent: AIAgent) -> void:
	if _paused:
		return

	if _active.is_empty():
		if not _start_next():
			return

	var t_name: String = String(_active.get("type", "unknown"))

	match t_name:
		"TaskMove":
			if not _started_current:
				_started_current = true
				agent.intent_move_begin(_active.get("point_m", Vector2.ZERO))
			if agent.intent_move_check():
				emit_signal("task_completed", unit_id, StringName(t_name))
				_active.clear()
				_started_current = false

		"TaskDefend":
			if not _started_current:
				_started_current = true
				agent.intent_defend_begin(
					_active.get("center_m", Vector2.ZERO), float(_active.get("radius", 0.0))
				)
			if agent.intent_defend_check():
				emit_signal("task_completed", unit_id, StringName(t_name))
				_active.clear()
				_started_current = false

		"TaskPatrol":
			if not _started_current:
				_started_current = true
				var pts: Array = _active.get("points_m", [])
				var typed: Array[Vector3] = []
				for p in pts:
					var v2: Vector2 = p as Vector2
					typed.append(Vector3(v2.x, 0.0, v2.y))
				# Optional dwell time per point
				agent.set_patrol_dwell(float(_active.get("dwell_s", 0.0)))
				agent.intent_patrol_begin(
					typed,
					bool(_active.get("ping_pong", false)),
					bool(_active.get("loop_forever", false))
				)
			if agent.intent_patrol_check():
				emit_signal("task_completed", unit_id, StringName(t_name))
				_active.clear()
				_started_current = false

		"TaskSetBehaviour":
			if not _started_current:
				_started_current = true
				agent.set_behaviour(int(_active.get("behaviour", 0)))
			emit_signal("task_completed", unit_id, StringName(t_name))
			_active.clear()
			_started_current = false

		"TaskSetCombatMode":
			if not _started_current:
				_started_current = true
				agent.set_combat_mode(int(_active.get("mode", 0)))
			emit_signal("task_completed", unit_id, StringName(t_name))
			_active.clear()
			_started_current = false

		"TaskWait":
			if not _started_current:
				_started_current = true
				agent.intent_wait_begin(
					float(_active.get("seconds", 0.0)), bool(_active.get("until_contact", false))
				)
			if agent.intent_wait_check(dt):
				emit_signal("task_completed", unit_id, StringName(t_name))
				_active.clear()
				_started_current = false

		_:
			emit_signal("task_failed", unit_id, StringName(t_name), StringName("unknown_task"))
			_active.clear()
			_started_current = false


## Block or unblock tasks by their scenario source index.
func block_task_index(idx: int, blocked: bool) -> void:
	var tasks: Array = _tasks_by_index.get(idx, [])
	if tasks.is_empty():
		return
	for task in tasks:
		task["_blocked"] = blocked
	if not _active.is_empty() and int(_active.get("__src_index", -1)) == idx:
		_active["_blocked"] = blocked
