# SubtitleEditor::_update_time_display Function Reference

*Defined at:* `scripts/ui/SubtitleEditor.gd` (lines 94–103)</br>
*Belongs to:* [SubtitleEditor](../../SubtitleEditor.md)

**Signature**

```gdscript
func _update_time_display() -> void
```

## Source

```gdscript
func _update_time_display() -> void:
	if not video_player.stream:
		time_label.text = "00:00.000 / 00:00.000"
		return

	var current := video_player.stream_position
	var duration := video_player.get_stream_length()
	time_label.text = "%s / %s" % [_format_time(current), _format_time(duration)]
```
