# TimerController::_update_lcd_display Function Reference

*Defined at:* `scripts/core/TimerController.gd` (lines 434–462)</br>
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
	if _lcd_label == null or _lcd_icon == null or _lcd_viewport == null:
		return

	var elapsed_sec: int = int(_sim_elapsed_time)
	var state_i: int = int(_current_state)
	if elapsed_sec == _lcd_last_elapsed_sec and state_i == _lcd_last_state:
		return

	_lcd_last_elapsed_sec = elapsed_sec
	_lcd_last_state = state_i

	var minutes: int = int(elapsed_sec / 60.0)
	var seconds: int = elapsed_sec % 60
	var time_str: String = "%02d:%02d" % [minutes, seconds]

	_lcd_label.text = time_str

	match _current_state:
		TimeState.PAUSED:
			_lcd_icon.texture = pause_icon
		TimeState.SPEED_1X:
			_lcd_icon.texture = play_icon
		TimeState.SPEED_2X:
			_lcd_icon.texture = fastforward_icon

	_lcd_viewport.render_target_update_mode = SubViewport.UPDATE_ONCE
```
