# SubtitleEditor::_on_video_file_selected Function Reference

*Defined at:* `scripts/ui/SubtitleEditor.gd` (lines 293–304)</br>
*Belongs to:* [SubtitleEditor](../../SubtitleEditor.md)

**Signature**

```gdscript
func _on_video_file_selected(path: String) -> void
```

## Source

```gdscript
func _on_video_file_selected(path: String) -> void:
	var video_stream := load(path)
	if video_stream is VideoStream:
		video_player.stream = video_stream
		_current_video_path = path
		video_player.play()
		_is_playing = true
		play_btn.text = "Pause"
	else:
		push_error("Failed to load video: %s" % path)
```
