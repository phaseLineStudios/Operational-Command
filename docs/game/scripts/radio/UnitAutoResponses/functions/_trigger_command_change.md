# UnitAutoResponses::_trigger_command_change Function Reference

*Defined at:* `scripts/radio/UnitAutoResponses.gd` (lines 703–713)</br>
*Belongs to:* [UnitAutoResponses](../../UnitAutoResponses.md)

**Signature**

```gdscript
func _trigger_command_change(unit_id: String) -> void
```

- **unit_id**: Unit experiencing command change.

## Description

Trigger command change announcement.

## Source

```gdscript
func _trigger_command_change(unit_id: String) -> void:
	var callsign: String = _id_to_callsign.get(unit_id, unit_id)

	var cmd_name := "Unknown"
	if not commander_names.is_empty():
		cmd_name = commander_names[_rng.randi() % commander_names.size()]

	var message := "This is %s taking command of %s." % [cmd_name, callsign]
	_queue_custom_message(unit_id, callsign, message, Priority.URGENT)
```
