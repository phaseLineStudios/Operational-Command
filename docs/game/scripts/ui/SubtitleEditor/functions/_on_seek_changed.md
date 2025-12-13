# SubtitleEditor::_on_seek_changed Function Reference

*Defined at:* `scripts/ui/SubtitleEditor.gd` (lines 175–179)</br>
*Belongs to:* [SubtitleEditor](../../SubtitleEditor.md)

**Signature**

```gdscript
func _on_seek_changed(value: float) -> void
```

## Source

```gdscript
func _on_seek_changed(value: float) -> void:
	if video_player.stream and _seeking:
		video_player.stream_position = value
```
