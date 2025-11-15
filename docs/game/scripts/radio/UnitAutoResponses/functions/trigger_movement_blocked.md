# UnitAutoResponses::trigger_movement_blocked Function Reference

*Defined at:* `scripts/radio/UnitAutoResponses.gd` (lines 540–551)</br>
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

	# Get specific phrase for this block reason
	var default_phrases: Array = EVENT_CONFIG[EventType.MOVEMENT_BLOCKED]["phrases"]
	var phrases: Array = MOVEMENT_BLOCKED_PHRASES.get(reason, default_phrases)
	var phrase: String = phrases[_rng.randi() % phrases.size()]

	# Queue message with specific phrase
	_queue_custom_message(unit_id, callsign, phrase, Priority.HIGH)
```
