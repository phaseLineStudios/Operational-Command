# ScenarioEditor::_on_save_file_selected Function Reference

*Defined at:* `scripts/editors/ScenarioEditor.gd` (lines 697–706)</br>
*Belongs to:* [ScenarioEditor](../ScenarioEditor.md)

**Signature**

```gdscript
func _on_save_file_selected(path: String) -> void
```

## Description

Handle file selection to save a scenario

## Source

```gdscript
func _on_save_file_selected(path: String) -> void:
	var fixed := persistence.ensure_json_ext(path)
	if persistence.save_to_path(ctx, fixed):
		_current_path = fixed
		_dirty = false
		_show_info("Saved: %s" % fixed)
	else:
		_show_info("Failed to save: %s" % fixed)
```
