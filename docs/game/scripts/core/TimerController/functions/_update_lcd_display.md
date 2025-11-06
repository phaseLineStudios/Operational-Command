# TimerController::_update_lcd_display Function Reference

*Defined at:* `scripts/core/TimerController.gd` (lines 445–469)</br>
*Belongs to:* [TimerController](../../TimerController.md)

**Signature**

```gdscript
func _update_lcd_display() -> void
```

## Description

Update LCD display with current time and mode.

## Source

```gdscript
func _update_lcd_display() -> void:
	if _lcd_label == null or _lcd_icon == null:
		return

	# Use accumulated simulation time
	var elapsed := _sim_elapsed_time

	# Format time as MM:SS
	var minutes := int(elapsed / 60.0)
	var seconds := int(elapsed) % 60
	var time_str := "%02d:%02d" % [minutes, seconds]

	# Update time label
	_lcd_label.text = time_str

	# Update icon based on current state
	match _current_state:
		TimeState.PAUSED:
			_lcd_icon.texture = pause_icon
		TimeState.SPEED_1X:
			_lcd_icon.texture = play_icon
		TimeState.SPEED_2X:
			_lcd_icon.texture = fastforward_icon
```
