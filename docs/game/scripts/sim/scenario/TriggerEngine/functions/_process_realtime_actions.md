# TriggerEngine::_process_realtime_actions Function Reference

*Defined at:* `scripts/sim/scenario/TriggerEngine.gd` (lines 401–418)</br>
*Belongs to:* [TriggerEngine](../../TriggerEngine.md)

**Signature**

```gdscript
func _process_realtime_actions() -> void
```

## Description

Process real-time scheduled actions that are ready to execute.

## Source

```gdscript
func _process_realtime_actions() -> void:
	var current_time := _realtime_accumulator
	var remaining: Array = []

	for action in _scheduled_actions:
		# Only process real-time actions
		if action.use_realtime:
			if action.execute_at <= current_time:
				# Execute the action
				_vm.run(action.expr, action.ctx)
			else:
				# Keep for later
				remaining.append(action)
		else:
			# Keep mission-time actions for _process_mission_time_actions
			remaining.append(action)

	_scheduled_actions = remaining
```
