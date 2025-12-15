# UnitAutoResponses::_on_order_failed Function Reference

*Defined at:* `scripts/radio/UnitAutoResponses.gd` (lines 566–586)</br>
*Belongs to:* [UnitAutoResponses](../../UnitAutoResponses.md)

**Signature**

```gdscript
func _on_order_failed(order: Dictionary, reason: String) -> void
```

- **order**: Order dictionary that failed.
- **reason**: Failure reason code.

## Description

Handle order failure.

## Source

```gdscript
func _on_order_failed(order: Dictionary, reason: String) -> void:
	var callsign: String = order.get("callsign", "")
	if callsign == "":
		return

	var unit_id: String = ""
	for uid in _id_to_callsign.keys():
		if _id_to_callsign[uid] == callsign:
			unit_id = uid
			break

	if unit_id == "":
		return

	var default_phrases: Array = event_config[EventType.ORDER_FAILED]["phrases"]
	var phrases: Array = order_failure_phrases.get(reason, default_phrases)
	var phrase: String = phrases[_rng.randi() % phrases.size()]

	_queue_custom_message(unit_id, callsign, phrase, Priority.NORMAL)
```
