# SubtitleEditor::_on_set_start_pressed Function Reference

*Defined at:* `scripts/ui/SubtitleEditor.gd` (lines 243–247)</br>
*Belongs to:* [SubtitleEditor](../../SubtitleEditor.md)

**Signature**

```gdscript
func _on_set_start_pressed() -> void
```

## Source

```gdscript
func _on_set_start_pressed() -> void:
	if video_player.stream:
		start_time_spin.value = video_player.stream_position
```
