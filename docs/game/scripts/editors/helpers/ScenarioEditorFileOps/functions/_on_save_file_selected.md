# ScenarioEditorFileOps::_on_save_file_selected Function Reference

*Defined at:* `scripts/editors/helpers/ScenarioEditorFileOps.gd` (lines 96–107)</br>
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
		var filename := fixed.get_file()
		editor.success_notification("Saved: %s" % filename, 2)
	else:
		var filename := fixed.get_file()
		editor.failed_notification("Failed to save: %s" % filename, 3)
```
