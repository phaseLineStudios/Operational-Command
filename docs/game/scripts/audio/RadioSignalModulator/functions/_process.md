# RadioSignalModulator::_process Function Reference

*Defined at:* `scripts/audio/RadioSignalModulator.gd` (lines 35–66)</br>
*Belongs to:* [RadioSignalModulator](../../RadioSignalModulator.md)

**Signature**

```gdscript
func _process(delta: float) -> void
```

## Source

```gdscript
func _process(delta: float) -> void:
	if _radio_bus_idx == -1:
		return

	_interference_timer += delta
	if _interference_timer >= 1.0:
		_interference_timer = 0.0
		if randf() < interference_chance:
			_target_strength = randf_range(min_signal_strength, min_signal_strength + 0.2)
		else:
			_target_strength = randf_range(max_signal_strength - 0.3, max_signal_strength)

	_signal_strength = lerp(_signal_strength, _target_strength, delta * fade_speed)

	var lowpass_effect: AudioEffectLowPassFilter = AudioServer.get_bus_effect(
		_radio_bus_idx, _lowpass_idx
	)
	if lowpass_effect:
		var cutoff: float = lerp(1200.0, BASE_LOWPASS_CUTOFF, _signal_strength)
		lowpass_effect.cutoff_hz = cutoff

	var distortion_effect: AudioEffectDistortion = AudioServer.get_bus_effect(
		_radio_bus_idx, _distortion_idx
	)
	if distortion_effect:
		var drive: float = lerp(
			BASE_DISTORTION_DRIVE * 3.0, BASE_DISTORTION_DRIVE, _signal_strength
		)
		distortion_effect.drive = drive

	var volume_db: float = lerp(-8.0, -2.5, _signal_strength)
	AudioServer.set_bus_volume_db(_radio_bus_idx, volume_db)
```
