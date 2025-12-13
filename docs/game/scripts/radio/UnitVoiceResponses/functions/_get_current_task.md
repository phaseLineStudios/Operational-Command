# UnitVoiceResponses::_get_current_task Function Reference

*Defined at:* `scripts/radio/UnitVoiceResponses.gd` (lines 394–414)</br>
*Belongs to:* [UnitVoiceResponses](../../UnitVoiceResponses.md)

**Signature**

```gdscript
func _get_current_task(unit: ScenarioUnit) -> String
```

- **unit**: ScenarioUnit to check.
- **Return Value**: Task description string or empty if none.

## Description

Get current task description for a unit.

## Source

```gdscript
func _get_current_task(unit: ScenarioUnit) -> String:
	var move_state := unit.move_state()
	match move_state:
		ScenarioUnit.MoveState.MOVING:
			var dest := unit.destination_m()
			if dest != Vector2.ZERO:
				var dir := _get_cardinal_direction(unit.position_m, dest)
				return "moving %s" % dir
			return "in transit"
		ScenarioUnit.MoveState.PLANNING:
			return "planning movement"
		ScenarioUnit.MoveState.PAUSED:
			return "movement paused"
		ScenarioUnit.MoveState.BLOCKED:
			return "movement blocked"
		ScenarioUnit.MoveState.IDLE:
			return "holding position"
		_:
			return ""
```
