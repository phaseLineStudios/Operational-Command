# TerrainEditor::_save_as Function Reference

*Defined at:* `scripts/editors/TerrainEditor.gd` (lines 386–412)</br>
*Belongs to:* [TerrainEditor](../../TerrainEditor.md)

**Signature**

```gdscript
func _save_as()
```

## Description

Save terrain as

## Source

```gdscript
func _save_as():
	if data == null:
		return
	var dlg := FileDialog.new()
	dlg.file_mode = FileDialog.FILE_MODE_SAVE_FILE
	dlg.access = FileDialog.ACCESS_FILESYSTEM
	dlg.add_filter("*.tres ; Text Resource")
	dlg.add_filter("*.res ; Binary Resource")
	add_child(dlg)
	dlg.popup_centered_ratio(0.5)
	dlg.file_selected.connect(
		func(path):
			var err := ResourceSaver.save(data, path)
			if err == OK:
				_current_path = path
				_saved_history_index = _current_history_index
				_dirty = false
				if _pending_quit_after_save:
					_pending_quit_after_save = false
					_perform_pending_exit()
			else:
				push_error("Save As failed: %s" % err)
			dlg.queue_free()
	)
	dlg.canceled.connect(func(): dlg.queue_free())
```
