# NewScenarioDialog::_on_subtitles_select Function Reference

*Defined at:* `scripts/editors/NewScenarioDialog.gd` (lines 191–210)</br>
*Belongs to:* [NewScenarioDialog](../../NewScenarioDialog.md)

**Signature**

```gdscript
func _on_subtitles_select() -> void
```

## Source

```gdscript
func _on_subtitles_select() -> void:
	var dlg := FileDialog.new()
	dlg.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	dlg.access = FileDialog.ACCESS_FILESYSTEM
	dlg.add_filter("*.tres ; Subtitle Track Resource")
	add_child(dlg)
	dlg.popup_centered_ratio(0.5)
	dlg.file_selected.connect(
		func(path):
			var resource := load(path)
			if resource is SubtitleTrack:
				subtitle_track = resource
				subtitles_path.text = path
			else:
				push_error("Not a SubtitleTrack resource: %s" % path)
			dlg.queue_free()
	)
	dlg.canceled.connect(func(): dlg.queue_free())
```
