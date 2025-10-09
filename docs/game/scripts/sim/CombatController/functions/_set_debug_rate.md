# CombatController::_set_debug_rate Function Reference

*Defined at:* `scripts/sim/Combat.gd` (lines 438–447)</br>
*Belongs to:* [CombatController](../../CombatController.md)

**Signature**

```gdscript
func _set_debug_rate() -> void
```

## Description

Adjust debug timer

## Source

```gdscript
func _set_debug_rate() -> void:
	if _debug_timer == null:
		return
	_debug_timer.wait_time = 1.0 / max(debug_poll_hz, 0.5)
	if debug_enabled:
		_debug_timer.start()
	else:
		_debug_timer.stop()
```
