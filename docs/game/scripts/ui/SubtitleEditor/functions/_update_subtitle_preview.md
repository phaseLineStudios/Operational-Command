# SubtitleEditor::_update_subtitle_preview Function Reference

*Defined at:* `scripts/ui/SubtitleEditor.gd` (lines 114–122)</br>
*Belongs to:* [SubtitleEditor](../../SubtitleEditor.md)

**Signature**

```gdscript
func _update_subtitle_preview() -> void
```

## Source

```gdscript
func _update_subtitle_preview() -> void:
	if not _subtitle_track or not video_player.is_playing():
		subtitle_preview.text = ""
		return

	var current_time := video_player.stream_position
	subtitle_preview.text = _subtitle_track.get_subtitle_at_time(current_time)
```
