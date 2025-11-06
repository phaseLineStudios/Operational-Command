# RadioSignalModulator::_ready Function Reference

*Defined at:* `scripts/audio/RadioSignalModulator.gd` (lines 29–40)</br>
*Belongs to:* [RadioSignalModulator](../../RadioSignalModulator.md)

**Signature**

```gdscript
func _ready() -> void
```

## Source

```gdscript
func _ready() -> void:
	_radio_bus_idx = AudioServer.get_bus_index("Radio")
	if _radio_bus_idx == -1:
		push_warning("RadioSignalModulator: Radio bus not found")
		set_process(false)
		return

	# Start with strong signal
	_signal_strength = max_signal_strength
	_target_strength = max_signal_strength
```
