# TerrainEditor::_on_exit_save_confirmed Function Reference

*Defined at:* `scripts/editors/TerrainEditor.gd` (lines 154–163)</br>
*Belongs to:* [TerrainEditor](../../TerrainEditor.md)

**Signature**

```gdscript
func _on_exit_save_confirmed() -> void
```

## Description

Save then exit

## Source

```gdscript
func _on_exit_save_confirmed() -> void:
	if _current_path == "":
		_pending_quit_after_save = true
		_save_as()
	else:
		_save()
		if not _pending_quit_after_save:
			_perform_pending_exit()
```
