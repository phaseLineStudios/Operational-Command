# SimDebugOverlay::_state_name Function Reference

*Defined at:* `scripts/sim/SimDebugOverlay.gd` (lines 343–358)</br>
*Belongs to:* [SimDebugOverlay](../../SimDebugOverlay.md)

**Signature**

```gdscript
func _state_name(s: int) -> String
```

## Description

Convert ScenarioUnit.MoveState to a compact label.
[param s] MoveState enum value.
[return] Short label string.

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
