# ScenarioTaskRunner::tick Function Reference

*Defined at:* `scripts/ai/tasks/ScenarioTaskRunner.gd` (lines 102–185)</br>
*Belongs to:* [ScenarioTaskRunner](../../ScenarioTaskRunner.md)

**Signature**

```gdscript
func tick(dt: float, agent: AIAgent) -> void
```

- **dt**: Delta time (seconds).
- **agent**: AIAgent that performs intents and completion checks.

## Description

Advance the active task using the supplied AIAgent.

## Source

```gdscript
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
```
