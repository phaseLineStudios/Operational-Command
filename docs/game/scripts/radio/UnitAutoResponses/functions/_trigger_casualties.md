# UnitAutoResponses::_trigger_casualties Function Reference

*Defined at:* `scripts/radio/UnitAutoResponses.gd` (lines 637–647)</br>
*Belongs to:* [UnitAutoResponses](../../UnitAutoResponses.md)

**Signature**

```gdscript
func _trigger_casualties(unit_id: String, casualties: int, current_strength: int) -> void
```

- **unit_id**: Unit that took casualties.
- **casualties**: Number of casualties.
- **current_strength**: Current unit strength.

## Description

Trigger casualties report.

## Source

```gdscript
func _trigger_casualties(unit_id: String, casualties: int, current_strength: int) -> void:
	var callsign: String = _id_to_callsign.get(unit_id, unit_id)
	var message: String

	if casualties < 5:
		_queue_message(unit_id, EventType.CASUALTIES_TAKEN)
	else:
		message = "%s is %d men strong." % [callsign, current_strength]
		_queue_custom_message(unit_id, callsign, message, Priority.HIGH)
```
