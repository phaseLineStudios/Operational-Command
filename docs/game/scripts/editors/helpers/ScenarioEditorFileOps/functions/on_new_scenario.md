# ScenarioEditorFileOps::on_new_scenario Function Reference

*Defined at:* `scripts/editors/helpers/ScenarioEditorFileOps.gd` (lines 104–117)</br>
*Belongs to:* [ScenarioEditorFileOps](../../ScenarioEditorFileOps.md)

**Signature**

```gdscript
func on_new_scenario(d: ScenarioData) -> void
```

- **d**: New scenario data.

## Description

Apply brand-new scenario data from dialog.

## Source

```gdscript
func on_new_scenario(d: ScenarioData) -> void:
	editor.ctx.data = d
	current_path = ""
	dirty = false
	editor._on_data_changed()

	if is_instance_valid(editor.history):
		editor.remove_child(editor.history)
	editor.history = ScenarioHistory.new()
	editor.add_child(editor.history)
	editor.ctx.history = editor.history
	editor.history.history_changed.connect(editor._on_history_changed)
```
