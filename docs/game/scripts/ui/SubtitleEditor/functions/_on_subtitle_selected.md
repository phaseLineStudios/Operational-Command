# SubtitleEditor::_on_subtitle_selected Function Reference

*Defined at:* `scripts/ui/SubtitleEditor.gd` (lines 253–270)</br>
*Belongs to:* [SubtitleEditor](../../SubtitleEditor.md)

**Signature**

```gdscript
func _on_subtitle_selected(index: int) -> void
```

## Source

```gdscript
func _on_subtitle_selected(index: int) -> void:
	if not _subtitle_track:
		return

	var subs := _subtitle_track.subtitles
	if index >= subs.size():
		return

	_selected_index = index
	var sub: Subtitle = subs[index]

	subtitle_text.text = sub.text
	start_time_spin.value = sub.start_time
	end_time_spin.value = sub.end_time

	_update_ui_state()
```
