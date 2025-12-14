# SubtitleEditor::_update_seek_slider Function Reference

*Defined at:* `scripts/ui/SubtitleEditor.gd` (lines 104–113)</br>
*Belongs to:* [SubtitleEditor](../../SubtitleEditor.md)

**Signature**

```gdscript
func _update_seek_slider() -> void
```

## Source

```gdscript
func _update_seek_slider() -> void:
	if not video_player.stream:
		seek_slider.max_value = 0.0
		seek_slider.value = 0.0
		return

	seek_slider.max_value = video_player.get_stream_length()
	seek_slider.value = video_player.stream_position
```
