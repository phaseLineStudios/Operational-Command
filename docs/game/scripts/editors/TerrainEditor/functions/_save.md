# TerrainEditor::_save Function Reference

*Defined at:* `scripts/editors/TerrainEditor.gd` (lines 368–384)</br>
*Belongs to:* [TerrainEditor](../TerrainEditor.md)

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
	var err := ResourceSaver.save(data, _current_path)
	if err != OK:
		push_error("Save failed: %s" % err)
	else:
		_saved_history_index = _current_history_index
		_dirty = false
		if _pending_quit_after_save:
			_pending_quit_after_save = false
			_perform_pending_exit()
```
