# SubtitleEditor::_on_track_file_selected Function Reference

*Defined at:* `scripts/ui/SubtitleEditor.gd` (lines 305–314)</br>
*Belongs to:* [SubtitleEditor](../../SubtitleEditor.md)

**Signature**

```gdscript
func _on_track_file_selected(path: String) -> void
```

## Source

```gdscript
func _on_track_file_selected(path: String) -> void:
	var resource := load(path)
	if resource is SubtitleTrack:
		_subtitle_track = resource
		_refresh_subtitle_list()
		_clear_editor()
	else:
		push_error("Failed to load subtitle track: %s" % path)
```
