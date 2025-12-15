# UnitAutoResponses::_on_unit_updated Function Reference

*Defined at:* `scripts/radio/UnitAutoResponses.gd` (lines 413–425)</br>
*Belongs to:* [UnitAutoResponses](../../UnitAutoResponses.md)

**Signature**

```gdscript
func _on_unit_updated(unit_id: String, snapshot: Dictionary) -> void
```

## Description

Handle unit state update - detect state changes.

## Source

```gdscript
func _on_unit_updated(unit_id: String, snapshot: Dictionary) -> void:
	var unit: ScenarioUnit = _units_by_id.get(unit_id)
	if not unit or not unit.playable:
		return

	var prev_state: Dictionary = _unit_states.get(unit_id, {})

	_check_movement_state(unit_id, prev_state, snapshot)
	_check_contact_changes(unit_id, prev_state, snapshot)
	_check_health_changes(unit_id, prev_state, snapshot)
	_unit_states[unit_id] = snapshot.duplicate()
```
