# TriggerAPI::sleep Function Reference

*Defined at:* `scripts/sim/scenario/TriggerAPI.gd` (lines 549–554)</br>
*Belongs to:* [TriggerAPI](../../TriggerAPI.md)

**Signature**

```gdscript
func sleep(duration_s: float) -> void
```

- **duration_s**: Duration in seconds (mission time) to pause execution

## Description

Pause execution for a duration (mission time).
All statements after this call will be delayed by the specified duration.
Uses mission time, so pausing the game pauses the sleep timer.

## Source

```gdscript
func sleep(duration_s: float) -> void:
	_sleep_requested = true
	_sleep_duration = duration_s
	_sleep_use_realtime = false
```
