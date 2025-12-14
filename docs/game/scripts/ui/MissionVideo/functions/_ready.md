# MissionVideo::_ready Function Reference

*Defined at:* `scripts/ui/MissionVideo.gd` (lines 26–42)</br>
*Belongs to:* [MissionVideo](../../MissionVideo.md)

**Signature**

```gdscript
func _ready() -> void
```

## Source

```gdscript
func _ready() -> void:
	AudioManager.stop_music(0.5)
	player.stream = Game.current_scenario.video
	player.play()
	player.finished.connect(_on_skip_pressed)

	_load_subtitles()

	hold_progress.min_value = 0.0
	hold_progress.max_value = HOLD_TO_SKIP_DURATION
	hold_progress.value = 0.0
	hold_progress.visible = false

	_last_mouse_pos = get_viewport().get_mouse_position()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
```
