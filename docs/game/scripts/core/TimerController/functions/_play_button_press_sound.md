# TimerController::_play_button_press_sound Function Reference

*Defined at:* `scripts/core/TimerController.gd` (lines 475–488)</br>
*Belongs to:* [TimerController](../../TimerController.md)

**Signature**

```gdscript
func _play_button_press_sound() -> void
```

## Description

Play a random button press sound

## Source

```gdscript
func _play_button_press_sound() -> void:
	if button_press_sounds.is_empty() or not _button_sound_player:
		return

	var sound := button_press_sounds[randi() % button_press_sounds.size()]
	_button_sound_player.stream = sound

	# Apply random pitch variation
	var pitch_offset := randf_range(-button_sound_pitch_variation, button_sound_pitch_variation)
	_button_sound_player.pitch_scale = 1.0 + pitch_offset

	_button_sound_player.play()
```
