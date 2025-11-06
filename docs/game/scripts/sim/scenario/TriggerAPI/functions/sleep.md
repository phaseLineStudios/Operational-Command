# TriggerAPI::sleep Function Reference

*Defined at:* `scripts/sim/scenario/TriggerAPI.gd` (lines 705–710)</br>
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
  
  

**Usage in trigger expressions:**

```
# Show sequential messages
show_dialog("First message")
sleep(5.0)
show_dialog("Second message after 5 seconds")
sleep(3.0)
show_dialog("Third message after 8 seconds total")

# Countdown sequence
radio("Starting countdown...")
sleep(3.0)
radio("3...")
sleep(3.0)
radio("2...")
sleep(3.0)
radio("1...")
sleep(3.0)
radio("Go!")
set_objective("start", 1)

# Dialog with position then delayed attack order
show_dialog("Watch this position", false, vec2(500, 500))
sleep(5.0)
show_dialog("Attack here!", false, vec2(1000, 1000))
sleep(2.0)
radio("All units, engage!")
```

## Source

```gdscript
func sleep(duration_s: float) -> void:
	_sleep_requested = true
	_sleep_duration = duration_s
	_sleep_use_realtime = false
```
