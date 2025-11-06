# ScenarioEditorFileOps::_on_open_file_selected Function Reference

*Defined at:* `scripts/editors/helpers/ScenarioEditorFileOps.gd` (lines 81–89)</br>
*Belongs to:* [ScenarioEditorFileOps](../../ScenarioEditorFileOps.md)

**Signature**

```gdscript
func _on_open_file_selected(path: String) -> void
```

- **path**: File path selected.

## Description

Handle file selection to open a scenario.

## Source

```gdscript
func _on_open_file_selected(path: String) -> void:
	if editor.persistence.load_from_path(editor.ctx, path):
		current_path = path
		dirty = false
		editor._on_data_changed()
	else:
		_show_info("Failed to open: %s" % path)
```
