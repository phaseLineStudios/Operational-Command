# TriggerEngine::_process Function Reference

*Defined at:* `scripts/sim/scenario/TriggerEngine.gd` (lines 39–47)</br>
*Belongs to:* [TriggerEngine](../../TriggerEngine.md)

**Signature**

```gdscript
func _process(dt: float) -> void
```

## Description

Tick triggers independently and track real-time.

## Source

```gdscript
func _process(dt: float) -> void:
	# Track real-time for sleep_ui
	_realtime_accumulator += dt
	# Process real-time scheduled actions (sleep_ui)
	_process_realtime_actions()
	if run_in_process:
		tick(dt)
```
