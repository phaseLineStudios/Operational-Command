# MissionVideo::_on_skip_pressed Function Reference

*Defined at:* `scripts/ui/MissionVideo.gd` (lines 94–99)</br>
*Belongs to:* [MissionVideo](../../MissionVideo.md)

**Signature**

```gdscript
func _on_skip_pressed() -> void
```

## Source

```gdscript
func _on_skip_pressed() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	AudioManager.play_music(AudioManager.main_menu_music)
	Game.goto_scene(SCENE_BRIEFING)
```
