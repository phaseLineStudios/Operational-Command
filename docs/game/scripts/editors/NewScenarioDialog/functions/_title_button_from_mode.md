# NewScenarioDialog::_title_button_from_mode Function Reference

*Defined at:* `scripts/editors/NewScenarioDialog.gd` (lines 139–147)</br>
*Belongs to:* [NewScenarioDialog](../NewScenarioDialog.md)

**Signature**

```gdscript
func _title_button_from_mode() -> void
```

## Description

Update window title and primary button text to reflect mode.

## Source

```gdscript
func _title_button_from_mode() -> void:
	if dialog_mode == DialogMode.CREATE:
		title = "New Scenario"
		create_btn.text = "Create"
	else:
		title = "Edit Scenario"
		create_btn.text = "Save"
```
