# NewScenarioDialog::_on_video_select Function Reference

*Defined at:* `scripts/editors/NewScenarioDialog.gd` (lines 171–185)</br>
*Belongs to:* [NewScenarioDialog](../../NewScenarioDialog.md)

**Signature**

```gdscript
func _on_video_select() -> void
```

## Source

```gdscript
func _on_video_select() -> void:
	var dlg := FileDialog.new()
	dlg.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	dlg.access = FileDialog.ACCESS_FILESYSTEM
	dlg.add_filter("*.ogv ; OGG Video")
	add_child(dlg)
	dlg.popup_centered_ratio(0.5)
	dlg.file_selected.connect(
		func(path):
			video_path.text = path
			dlg.queue_free()
	)
	dlg.canceled.connect(func(): dlg.queue_free())
```
