# TriggerEngine::tick Function Reference

*Defined at:* `scripts/sim/scenario/TriggerEngine.gd` (lines 77–86)</br>
*Belongs to:* [TriggerEngine](../../TriggerEngine.md)

**Signature**

```gdscript
func tick(dt: float) -> void
```

- **dt**: delta time from last tick.

## Description

Deterministic evaluation entry point.

## Source

```gdscript
func tick(dt: float) -> void:
	_refresh_unit_indices()
	_process_mission_time_actions()
	for t in _scenario.triggers:
		_evaluate_trigger(t, dt)
	# Clear radio command after all triggers evaluated
	_last_radio_text = ""
	_api._set_last_radio_command("")
```
