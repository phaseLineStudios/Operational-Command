extends Node
class_name ScenarioTaskRunner

## Runs a deterministic chain of authored tasks for one unit and emits lifecycle events.
##
## Expected task dictionaries:
##   { "type": "TaskMove", "point": Vector3 }
##   { "type": "TaskDefend", "center": Vector3, "radius": 25.0 }
##   { "type": "TaskPatrol", "points": Array[Vector3], "ping_pong": bool }
##   { "type": "TaskSetBehaviour", "behaviour": int }
##   { "type": "TaskSetCombatMode", "mode": int }
##   { "type": "TaskWait", "seconds": float, "until_contact": bool }

signal task_started(unit_id: int, task_type: StringName)
signal task_completed(unit_id: int, task_type: StringName)
signal task_failed(unit_id: int, task_type: StringName, reason: StringName)

var unit_id: int = -1
var _queue: Array[Dictionary] = []
var _active: Dictionary = {}
var _paused: bool = false
var _started_current: bool = false

func setup(p_unit_id: int, ordered_tasks: Array[Dictionary]) -> void:
	unit_id = p_unit_id
	_queue = ordered_tasks.duplicate(true)
	_active = {}
	_paused = false
	_started_current = false

func is_idle() -> bool:
	return _active.is_empty() and _queue.is_empty()

func pause() -> void:
	_paused = true

func resume() -> void:
	_paused = false

func cancel_active() -> void:
	_active.clear()
	_started_current = false

func advance() -> void:
	_active.clear()
	_started_current = false

func _start_next() -> void:
	if _queue.is_empty():
		_active = {}
		_started_current = false
		return
	_active = _queue.pop_front()
	_started_current = false
	emit_signal("task_started", unit_id, StringName(_active.get("type", "unknown")))

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
				agent.intent_move_begin(_active.get("point", Vector3()))
			if agent.intent_move_check():
				emit_signal("task_completed", unit_id, StringName(t_name))
				_active.clear()
				_started_current = false

		"TaskDefend":
			if not _started_current:
				_started_current = true
				agent.intent_defend_begin(
					_active.get("center", Vector3()),
					float(_active.get("radius", 0.0))
				)
			if agent.intent_defend_check():
				emit_signal("task_completed", unit_id, StringName(t_name))
				_active.clear()
				_started_current = false

		"TaskPatrol":
			if not _started_current:
				_started_current = true
				var pts: Array = _active.get("points", [])
				var typed: Array[Vector3] = []
				for p in pts:
					typed.append(p as Vector3)
				agent.intent_patrol_begin(typed, bool(_active.get("ping_pong", false)))
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
					float(_active.get("seconds", 0.0)),
					bool(_active.get("until_contact", false))
				)
			if agent.intent_wait_check(dt):
				emit_signal("task_completed", unit_id, StringName(t_name))
				_active.clear()
				_started_current = false

		_:
			emit_signal("task_failed", unit_id, StringName(t_name), StringName("unknown_task"))
			_active.clear()
			_started_current = false
