# SimDebugOverlay::_state_name Function Reference

*Defined at:* `scripts/sim/SimDebugOverlay.gd` (lines 372–387)</br>
*Belongs to:* [SimDebugOverlay](../../SimDebugOverlay.md)

**Signature**

```gdscript
func _state_name(s: int) -> String
```

- **s**: MoveState enum value.
- **Return Value**: Short label string.

## Description

Convert ScenarioUnit.MoveState to a compact label.

## Source

```gdscript
func _state_name(s: int) -> String:
	match s:
		ScenarioUnit.MoveState.IDLE:
			return "IDLE"
		ScenarioUnit.MoveState.PLANNING:
			return "PLAN"
		ScenarioUnit.MoveState.MOVING:
			return "MOVE"
		ScenarioUnit.MoveState.PAUSED:
			return "PAUSE"
		ScenarioUnit.MoveState.BLOCKED:
			return "BLOCK"
		ScenarioUnit.MoveState.ARRIVED:
			return "ARRIVE"
		_:
			return str(s)
```
