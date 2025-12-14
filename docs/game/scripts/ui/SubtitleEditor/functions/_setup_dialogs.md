# SubtitleEditor::_setup_dialogs Function Reference

*Defined at:* `scripts/ui/SubtitleEditor.gd` (lines 74–87)</br>
*Belongs to:* [SubtitleEditor](../../SubtitleEditor.md)

**Signature**

```gdscript
func _setup_dialogs() -> void
```

## Source

```gdscript
func _setup_dialogs() -> void:
	video_dialog.access = FileDialog.ACCESS_FILESYSTEM
	video_dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	video_dialog.filters = ["*.ogv ; OGG Video"]

	load_track_dialog.access = FileDialog.ACCESS_FILESYSTEM
	load_track_dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	load_track_dialog.filters = ["*.tres ; Subtitle Track Resource"]

	save_track_dialog.access = FileDialog.ACCESS_FILESYSTEM
	save_track_dialog.file_mode = FileDialog.FILE_MODE_SAVE_FILE
	save_track_dialog.filters = ["*.tres ; Subtitle Track Resource"]
```
