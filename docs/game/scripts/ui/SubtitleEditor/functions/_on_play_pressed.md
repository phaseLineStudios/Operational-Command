# SubtitleEditor::_on_play_pressed Function Reference

*Defined at:* `scripts/ui/SubtitleEditor.gd` (lines 159–174)</br>
*Belongs to:* [SubtitleEditor](../../SubtitleEditor.md)

**Signature**

```gdscript
func _on_play_pressed() -> void
```

## Source

```gdscript
func _on_play_pressed() -> void:
	if not video_player.stream:
		return

	if _is_playing:
		video_player.paused = true
		play_btn.text = "Play"
		_is_playing = false
	else:
		video_player.paused = false
		if not video_player.is_playing():
			video_player.play()
		play_btn.text = "Pause"
		_is_playing = true
```
