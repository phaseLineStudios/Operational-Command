# ScenarioEditorFileOps::_on_save_file_selected Function Reference

*Defined at:* `scripts/editors/helpers/ScenarioEditorFileOps.gd` (lines 92–101)</br>
*Belongs to:* [ScenarioEditorFileOps](../../ScenarioEditorFileOps.md)

**Signature**

```gdscript
func _on_save_file_selected(path: String) -> void
```

- **path**: File path selected.

## Description

Handle file selection to save a scenario.

## Source

```gdscript
func _on_save_file_selected(path: String) -> void:
	var fixed := editor.persistence.ensure_json_ext(path)
	if editor.persistence.save_to_path(editor.ctx, fixed):
		current_path = fixed
		dirty = false
		_show_info("Saved: %s" % fixed)
	else:
		_show_info("Failed to save: %s" % fixed)
```
