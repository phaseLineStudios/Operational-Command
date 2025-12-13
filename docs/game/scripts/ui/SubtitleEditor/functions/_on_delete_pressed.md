# SubtitleEditor::_on_delete_pressed Function Reference

*Defined at:* `scripts/ui/SubtitleEditor.gd` (lines 230–242)</br>
*Belongs to:* [SubtitleEditor](../../SubtitleEditor.md)

**Signature**

```gdscript
func _on_delete_pressed() -> void
```

## Source

```gdscript
func _on_delete_pressed() -> void:
	if not _subtitle_track or _selected_index < 0:
		return

	var subs := _subtitle_track.subtitles
	if _selected_index >= subs.size():
		return

	subs.remove_at(_selected_index)
	_refresh_subtitle_list()
	_clear_editor()
```
