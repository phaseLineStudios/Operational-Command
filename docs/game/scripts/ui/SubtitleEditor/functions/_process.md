# SubtitleEditor::_process Function Reference

*Defined at:* `scripts/ui/SubtitleEditor.gd` (lines 42–48)</br>
*Belongs to:* [SubtitleEditor](../../SubtitleEditor.md)

**Signature**

```gdscript
func _process(_delta: float) -> void
```

## Source

```gdscript
func _process(_delta: float) -> void:
	if video_player.stream and not _seeking:
		_update_time_display()
		_update_seek_slider()
		_update_subtitle_preview()
```
