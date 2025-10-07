# ScenarioEditor::_on_open_file_selected Function Reference

*Defined at:* `scripts/editors/ScenarioEditor.gd` (lines 687–695)</br>
*Belongs to:* [ScenarioEditor](../../ScenarioEditor.md)

**Signature**

```gdscript
func _on_open_file_selected(path: String) -> void
```

## Description

Handle file selection to open a scenario

## Source

```gdscript
func _on_open_file_selected(path: String) -> void:
	if persistence.load_from_path(ctx, path):
		_current_path = path
		_dirty = false
		_on_data_changed()
	else:
		_show_info("Failed to open: %s" % path)
```
