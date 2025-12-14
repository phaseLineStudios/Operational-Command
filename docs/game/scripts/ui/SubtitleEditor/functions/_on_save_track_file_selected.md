# SubtitleEditor::_on_save_track_file_selected Function Reference

*Defined at:* `scripts/ui/SubtitleEditor.gd` (lines 315–323)</br>
*Belongs to:* [SubtitleEditor](../../SubtitleEditor.md)

**Signature**

```gdscript
func _on_save_track_file_selected(path: String) -> void
```

## Source

```gdscript
func _on_save_track_file_selected(path: String) -> void:
	if not _subtitle_track:
		return

	var err := ResourceSaver.save(_subtitle_track, path)
	if err == OK:
		print("Subtitle track saved to: %s" % path)
	else:
		push_error("Failed to save subtitle track: %s" % path)
```
