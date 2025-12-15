# UnitAutoResponses::_check_movement_state Function Reference

*Defined at:* `scripts/radio/UnitAutoResponses.gd` (lines 427–447)</br>
*Belongs to:* [UnitAutoResponses](../../UnitAutoResponses.md)

**Signature**

```gdscript
func _check_movement_state(unit_id: String, prev: Dictionary, current: Dictionary) -> void
```

## Description

Check for movement state changes.

## Source

```gdscript
func _check_movement_state(unit_id: String, prev: Dictionary, current: Dictionary) -> void:
	var unit: ScenarioUnit = _units_by_id.get(unit_id)
	if not unit:
		return

	const IDLE = 0
	const MOVING = 2
	const ARRIVED = 5

	var prev_movement_state: int = prev.get("movement_state", IDLE)
	var curr_movement_state: int = unit.move_state()

	if prev_movement_state == IDLE and curr_movement_state == MOVING:
		_queue_message(unit_id, EventType.MOVEMENT_STARTED)

	elif prev_movement_state == MOVING and curr_movement_state == ARRIVED:
		_queue_message(unit_id, EventType.POSITION_REACHED)

	current["movement_state"] = curr_movement_state
```
