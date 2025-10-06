# Radio::_unhandled_input Function Reference

*Defined at:* `scripts/radio/Radio.gd` (lines 25–37)</br>
*Belongs to:* [Radio](../Radio.md)

**Signature**

```gdscript
func _unhandled_input(event: InputEvent) -> void
```

## Description

Handle PTT input.

## Source

```gdscript
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.echo:
		return

	if event.is_action_pressed("ptt"):
		_start_tx()
		# prevent UI from also handling it
		get_viewport().set_input_as_handled()
	elif event.is_action_released("ptt"):
		_stop_tx()
		get_viewport().set_input_as_handled()
```
