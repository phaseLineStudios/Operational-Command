# TriggerAPI::sleep_ui Function Reference

*Defined at:* `scripts/sim/scenario/TriggerAPI.gd` (lines 733–738)</br>
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
  
  

**Usage in trigger expressions:**

```
# Tutorial sequence that continues even if player pauses
show_dialog("Welcome to the tutorial", true)
sleep_ui(2.0)
show_dialog("Step 1: Use radio checks", true)
sleep_ui(3.0)
show_dialog("Step 2: Place markers", true)

# Timed UI feedback
radio("Command acknowledged")
sleep_ui(1.5)
radio("Executing order...")
sleep_ui(2.0)
radio("Order complete")
```

## Source

```gdscript
func sleep_ui(duration_s: float) -> void:
	_sleep_requested = true
	_sleep_duration = duration_s
	_sleep_use_realtime = true
```
