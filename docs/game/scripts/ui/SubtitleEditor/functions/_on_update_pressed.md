# SubtitleEditor::_on_update_pressed Function Reference

*Defined at:* `scripts/ui/SubtitleEditor.gd` (lines 201–229)</br>
*Belongs to:* [SubtitleEditor](../../SubtitleEditor.md)

**Signature**

```gdscript
func _on_update_pressed() -> void
```

## Source

```gdscript
func _on_update_pressed() -> void:
	if not _subtitle_track or _selected_index < 0:
		return

	var subs := _subtitle_track.subtitles
	if _selected_index >= subs.size():
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

	var sub: Subtitle = subs[_selected_index]
	sub.start_time = start
	sub.end_time = end
	sub.text = text

	_refresh_subtitle_list()
	_clear_editor()
```
