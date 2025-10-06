# TaskConfigDialog::show_for Function Reference

*Defined at:* `scripts/editors/TaskConfigDialog.gd` (lines 24–31)</br>
*Belongs to:* [TaskConfigDialog](../TaskConfigDialog.md)

**Signature**

```gdscript
func show_for(_editor: ScenarioEditor, inst: ScenarioTask) -> void
```

## Source

```gdscript
func show_for(_editor: ScenarioEditor, inst: ScenarioTask) -> void:
	editor = _editor
	instance = inst
	_before = instance.duplicate(true)
	_build_form()
	visible = true
```
