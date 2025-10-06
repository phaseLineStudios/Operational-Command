# ScenarioEditor::_on_new_scenario Function Reference

*Defined at:* `scripts/editors/ScenarioEditor.gd` (lines 708–721)</br>
*Belongs to:* [ScenarioEditor](../ScenarioEditor.md)

**Signature**

```gdscript
func _on_new_scenario(d: ScenarioData) -> void
```

## Description

Apply brand-new scenario data from dialog

## Source

```gdscript
func _on_new_scenario(d: ScenarioData) -> void:
	ctx.data = d
	_current_path = ""
	_dirty = false
	_on_data_changed()

	if is_instance_valid(history):
		remove_child(history)
	history = ScenarioHistory.new()
	add_child(history)
	ctx.history = history
	history.history_changed.connect(_on_history_changed)
```
