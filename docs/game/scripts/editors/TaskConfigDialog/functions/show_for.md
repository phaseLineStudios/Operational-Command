# TaskConfigDialog::show_for Function Reference

*Defined at:* `scripts/editors/TaskConfigDialog.gd` (lines 26–35)</br>
*Belongs to:* [TaskConfigDialog](../../TaskConfigDialog.md)

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
	pos_x_in.value = instance.position_m.x
	pos_y_in.value = instance.position_m.y
	_build_form()
	visible = true
```
