# UnitAutoResponses::_report_contact_spotted Function Reference

*Defined at:* `scripts/radio/UnitAutoResponses.gd` (lines 562–590)</br>
*Belongs to:* [UnitAutoResponses](../../UnitAutoResponses.md)

**Signature**

```gdscript
func _report_contact_spotted(spotter_id: String, contact_id: String) -> void
```

- **spotter_id**: Unit that spotted the contact.
- **contact_id**: Enemy unit that was spotted.

## Description

Generate and queue descriptive contact report.

## Source

```gdscript
func _report_contact_spotted(spotter_id: String, contact_id: String) -> void:
	var event_key := "%s:%d" % [spotter_id, EventType.CONTACT_SPOTTED]
	var current_time := Time.get_ticks_msec() / 1000.0
	var last_trigger_time: float = _event_last_triggered.get(event_key, 0.0)
	var cooldown: float = EVENT_CONFIG[EventType.CONTACT_SPOTTED].get("cooldown_s", 15.0)

	if current_time - last_trigger_time < cooldown:
		return

	var spotter_callsign: String = _id_to_callsign.get(spotter_id, spotter_id)
	var contact_unit = _units_by_id.get(contact_id)
	if not contact_unit:
		_queue_message(spotter_id, EventType.CONTACT_SPOTTED)
		return

	var description := _get_unit_description(contact_unit)
	var grid_pos := _get_grid_from_position(contact_unit.position_m)

	var message := "Contact! %s at grid %s." % [description, grid_pos]
	var priority: Priority = EVENT_CONFIG[EventType.CONTACT_SPOTTED].get("priority", Priority.HIGH)
	var msg := VoiceMessage.new(spotter_id, spotter_callsign, message, priority, current_time)

	if _message_queue.size() >= max_queue_size:
		_message_queue.remove_at(_message_queue.size() - 1)

	_message_queue.append(msg)
	_event_last_triggered[event_key] = current_time
```
