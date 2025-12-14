# SubtitleEditor::_on_add_pressed Function Reference

*Defined at:* `scripts/ui/SubtitleEditor.gd` (lines 180–200)</br>
*Belongs to:* [SubtitleEditor](../../SubtitleEditor.md)

**Signature**

```gdscript
func _on_add_pressed() -> void
```

## Source

```gdscript
func _on_add_pressed() -> void:
	if not _subtitle_track:
		return

	var start := start_time_spin.value
	var end := end_time_spin.value
	var text := subtitle_text.text

	if text.is_empty():
		push_warning("Subtitle text cannot be empty")
		return

	if end <= start:
		push_warning("End time must be greater than start time")
		return

	_subtitle_track.add_subtitle(start, end, text)
	_refresh_subtitle_list()
	_clear_editor()
```
