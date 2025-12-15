# UnitAutoResponses::trigger_movement_blocked Function Reference

*Defined at:* `scripts/radio/UnitAutoResponses.gd` (lines 676–685)</br>
*Belongs to:* [UnitAutoResponses](../../UnitAutoResponses.md)

**Signature**

```gdscript
func trigger_movement_blocked(unit_id: String, reason: String) -> void
```

- **unit_id**: Unit that is blocked.
- **reason**: Block reason code.

## Description

Handle movement blocked event.

## Source

```gdscript
func trigger_movement_blocked(unit_id: String, reason: String) -> void:
	var callsign: String = _id_to_callsign.get(unit_id, unit_id)

	var default_phrases: Array = event_config[EventType.MOVEMENT_BLOCKED]["phrases"]
	var phrases: Array = movement_blocked_phrases.get(reason, default_phrases)
	var phrase: String = phrases[_rng.randi() % phrases.size()]

	_queue_custom_message(unit_id, callsign, phrase, Priority.HIGH)
```
