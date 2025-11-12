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


## Initialize this runner for a unit and its ordered task list.
## [param p_unit_id] Unit index in ScenarioData.units.
## [param ordered_tasks] Runner-ready tasks in execution order.
func setup(p_unit_id: int, ordered_tasks: Array[Dictionary]) -> void:
	unit_id = p_unit_id
	_queue = ordered_tasks.duplicate(true)
	_active = {}
	_paused = false
	_started_current = false


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


## Pop the next task and emit task_started; no-op if queue is empty.
func _start_next() -> void:
	if _queue.is_empty():
		_active = {}
		_started_current = false
		return
	_active = _queue.pop_front()
	_started_current = false
	emit_signal("task_started", unit_id, StringName(_active.get("type", "unknown")))


## Advance the active task using the supplied AIAgent.
## [param dt] Delta time (seconds).
## [param agent] AIAgent that performs intents and completion checks.
func tick(dt: float, agent: AIAgent) -> void:
	if _paused:
		return

	if _active.is_empty():
		_start_next()
		if _active.is_empty():
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
