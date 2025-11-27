# TerrainEditor::_save Function Reference

*Defined at:* `scripts/editors/TerrainEditor.gd` (lines 368–390)</br>
*Belongs to:* [TerrainEditor](../../TerrainEditor.md)

**Signature**

```gdscript
func _save()
```

## Description

Save terrain

## Source

```gdscript
func _save():
	if data == null:
		return
	if _current_path == "":
		_save_as()
		return
	var srl := JSON.stringify(data.serialize())
	var f := FileAccess.open(_current_path, FileAccess.WRITE)
	if f == null:
		return false
	var ok := f.store_string(srl)
	f.flush()
	f.close()
	if not ok:
		LogService.error("Save failed", "TerrainEditor.gd:382")
	else:
		_saved_history_index = _current_history_index
		_dirty = false
		if _pending_quit_after_save:
			_pending_quit_after_save = false
			_perform_pending_exit()
```
