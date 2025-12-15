# UnitAutoResponses::_on_queue_timer_timeout Function Reference

*Defined at:* `scripts/radio/UnitAutoResponses.gd` (lines 306–335)</br>
*Belongs to:* [UnitAutoResponses](../../UnitAutoResponses.md)

**Signature**

```gdscript
func _on_queue_timer_timeout() -> void
```

## Description

Called when queue timer times out.
process and emit queued voice messages.

## Source

```gdscript
func _on_queue_timer_timeout() -> void:
	if _message_queue.is_empty():
		_queue_timer.stop()
		return

	var current_time := Time.get_ticks_msec() / 1000.0

	# Check global cooldown
	if current_time - _last_message_time < global_cooldown_s:
		return

	_message_queue.sort_custom(_compare_messages)
	var msg := _message_queue[0]

	# Check per-unit cooldown
	var unit_last_time: float = _unit_last_message.get(msg.unit_id, 0.0)
	if current_time - unit_last_time < per_unit_cooldown_s:
		return

	_emit_voice_message(msg)
	_message_queue.remove_at(0)

	_last_message_time = current_time
	_unit_last_message[msg.unit_id] = current_time

	# Stop timer if queue is now empty
	if _message_queue.is_empty():
		_queue_timer.stop()
```
