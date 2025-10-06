# NewScenarioDialog::show_dialog Function Reference

*Defined at:* `scripts/editors/NewScenarioDialog.gd` (lines 149–163)</br>
*Belongs to:* [NewScenarioDialog](../NewScenarioDialog.md)

**Signature**

```gdscript
func show_dialog(state: bool, existing: ScenarioData = null) -> void
```

## Description

Show/hide dialog.

## Source

```gdscript
func show_dialog(state: bool, existing: ScenarioData = null) -> void:
	if not state:
		visible = false
		_reset_values()
		return

	if existing:
		dialog_mode = DialogMode.EDIT
		working = existing
		_load_from_data(existing)
	else:
		dialog_mode = DialogMode.CREATE

	_title_button_from_mode()
	visible = true
```
