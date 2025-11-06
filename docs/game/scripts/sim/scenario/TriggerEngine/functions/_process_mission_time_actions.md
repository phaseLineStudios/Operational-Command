# TriggerEngine::_process_mission_time_actions Function Reference

*Defined at:* `scripts/sim/scenario/TriggerEngine.gd` (lines 378–399)</br>
*Belongs to:* [TriggerEngine](../../TriggerEngine.md)

**Signature**

```gdscript
func _process_mission_time_actions() -> void
```

## Description

Process mission-time scheduled actions that are ready to execute.

## Source

```gdscript
func _process_mission_time_actions() -> void:
	if not _sim:
		return
	var current_time := _sim.get_mission_time_s()
	var remaining: Array = []

	for action in _scheduled_actions:
		# Only process mission-time actions
		if not action.use_realtime:
			if action.execute_at <= current_time:
				# Execute the action
				_vm.run(action.expr, action.ctx)
			else:
				# Keep for later
				remaining.append(action)
		else:
			# Keep real-time actions for _process_realtime_actions
			remaining.append(action)

	_scheduled_actions = remaining
```
