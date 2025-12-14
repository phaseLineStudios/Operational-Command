# SubtitleEditor::_on_set_end_pressed Function Reference

*Defined at:* `scripts/ui/SubtitleEditor.gd` (lines 248–252)</br>
*Belongs to:* [SubtitleEditor](../../SubtitleEditor.md)

**Signature**

```gdscript
func _on_set_end_pressed() -> void
```

## Source

```gdscript
func _on_set_end_pressed() -> void:
	if video_player.stream:
		end_time_spin.value = video_player.stream_position
```
