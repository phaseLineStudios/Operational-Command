# TriggerEngine::bind_radio Function Reference

*Defined at:* `scripts/sim/scenario/TriggerEngine.gd` (lines 60–67)</br>
*Belongs to:* [TriggerEngine](../../TriggerEngine.md)

**Signature**

```gdscript
func bind_radio(radio: Radio) -> void
```

- **radio**: Radio node emitting `signal Radio.radio_raw_command` signal.

## Description

Bind radio to listen for raw commands.
Connects to `signal Radio.radio_raw_command` to capture voice input before parsing.
Makes raw text available to triggers via `method TriggerAPI.last_radio_command`.
  
  

**Called automatically by SimWorld.bind_radio().**

## Source

```gdscript
func bind_radio(radio: Radio) -> void:
	if _radio and _radio.radio_raw_command.is_connected(_on_radio_raw):
		_radio.radio_raw_command.disconnect(_on_radio_raw)
	_radio = radio
	if _radio and not _radio.radio_raw_command.is_connected(_on_radio_raw):
		_radio.radio_raw_command.connect(_on_radio_raw)
```

## References

- [`signal Radio.radio_raw_command`](../../../../radio/Radio.md#radio_raw_command)
- [`method TriggerAPI.last_radio_command`](../../TriggerAPI/functions/last_radio_command.md)
