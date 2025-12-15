# TriggerAPI::sleep_ui Function Reference

*Defined at:* `scripts/sim/scenario/TriggerAPI.gd` (lines 560–565)</br>
*Belongs to:* [TriggerAPI](../../TriggerAPI.md)

**Signature**

```gdscript
func sleep_ui(duration_s: float) -> void
```

- **duration_s**: Duration in seconds (real-time) to pause execution

## Description

Pause execution for a duration (real-time).
All statements after this call will be delayed by the specified duration.
Uses real-time, so the sleep continues even when the game is paused.
Useful for UI sequences and tutorials.

## Source

```gdscript
func sleep_ui(duration_s: float) -> void:
	_sleep_requested = true
	_sleep_duration = duration_s
	_sleep_use_realtime = true
```
