# UnitAutoResponses::_process_message_queue Function Reference

*Defined at:* `scripts/radio/UnitAutoResponses.gd` (lines 352–374)</br>
*Belongs to:* [UnitAutoResponses](../../UnitAutoResponses.md)

**Signature**

```gdscript
func _process_message_queue(_delta: float) -> void
```

## Description

Process and emit queued voice messages.

## Source

```gdscript
func _process_message_queue(_delta: float) -> void:
	if _message_queue.is_empty():
		return

	var current_time := Time.get_ticks_msec() / 1000.0

	if current_time - _last_message_time < global_cooldown_s:
		return

	_message_queue.sort_custom(_compare_messages)
	var msg := _message_queue[0]

	var unit_last_time: float = _unit_last_message.get(msg.unit_id, 0.0)
	if current_time - unit_last_time < per_unit_cooldown_s:
		return

	_emit_voice_message(msg)
	_message_queue.remove_at(0)

	_last_message_time = current_time
	_unit_last_message[msg.unit_id] = current_time
```
