# UnitAutoResponses::_queue_message Function Reference

*Defined at:* `scripts/radio/UnitAutoResponses.gd` (lines 355–388)</br>
*Belongs to:* [UnitAutoResponses](../../UnitAutoResponses.md)

**Signature**

```gdscript
func _queue_message(unit_id: String, event_type: EventType) -> void
```

## Description

Queue a voice message for a unit.

## Source

```gdscript
func _queue_message(unit_id: String, event_type: EventType) -> void:
	# Only queue messages for playable units
	var unit = _units_by_id.get(unit_id)
	if not unit or not unit.playable:
		return

	var event_key := "%s:%d" % [unit_id, event_type]
	var current_time := Time.get_ticks_msec() / 1000.0
	var last_trigger_time: float = _event_last_triggered.get(event_key, 0.0)
	var cooldown: float = event_config[event_type].get("cooldown_s", 10.0)

	if current_time - last_trigger_time < cooldown:
		return

	var callsign: String = _id_to_callsign.get(unit_id, unit_id)
	var phrases: Array = event_config[event_type].get("phrases", [])
	if phrases.is_empty():
		return
	var phrase: String = phrases[_rng.randi() % phrases.size()]

	var priority: Priority = event_config[event_type].get("priority", Priority.NORMAL)
	var msg := VoiceMessage.new(unit_id, callsign, phrase, priority, current_time)

	if _message_queue.size() >= max_queue_size:
		_message_queue.remove_at(_message_queue.size() - 1)

	_message_queue.append(msg)
	_event_last_triggered[event_key] = current_time

	# Start queue timer if not already running
	if _queue_timer and _queue_timer.is_stopped():
		_queue_timer.start()
```
