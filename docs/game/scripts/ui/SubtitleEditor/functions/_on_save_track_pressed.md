# SubtitleEditor::_on_save_track_pressed Function Reference

*Defined at:* `scripts/ui/SubtitleEditor.gd` (lines 283–288)</br>
*Belongs to:* [SubtitleEditor](../../SubtitleEditor.md)

**Signature**

```gdscript
func _on_save_track_pressed() -> void
```

## Source

```gdscript
func _on_save_track_pressed() -> void:
	if not _subtitle_track:
		return
	save_track_dialog.popup_centered()
```
