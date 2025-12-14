# SimWorld::_on_radio_command_for_triggers Function Reference

*Defined at:* `scripts/sim/SimWorld.gd` (lines 718–736)</br>
*Belongs to:* [SimWorld](../../SimWorld.md)

**Signature**

```gdscript
func _on_radio_command_for_triggers(text: String) -> void
```

- **text**: Raw text from STT.

## Description

Handle radio commands and auto-activate triggers for matching custom commands.
Connected to `signal Radio.radio_raw_command` in `method bind_radio`.

## Source

```gdscript
func _on_radio_command_for_triggers(text: String) -> void:
	if not _scenario:
		return
	var normalized := text.strip_edges().to_lower()
	for cmd in _scenario.custom_commands:
		if cmd is CustomCommand and cmd.keyword != "" and cmd.trigger_id != "":
			if normalized == cmd.keyword.to_lower():
				if trigger_engine:
					trigger_engine.activate_trigger(cmd.trigger_id)
					LogService.trace(
						(
							"Custom command '%s' activated trigger '%s'"
							% [cmd.keyword, cmd.trigger_id]
						),
						"SimWorld.gd"
					)
				break
```

## References

- [`signal Radio.radio_raw_command`](../../../radio/Radio.md#radio_raw_command)
- [`method bind_radio`](bind_radio.md)
