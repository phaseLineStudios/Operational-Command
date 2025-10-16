# BriefingDialog::show_dialog Function Reference

*Defined at:* `scripts/editors/BriefingDialog.gd` (lines 45–63)</br>
*Belongs to:* [BriefingDialog](../../BriefingDialog.md)

**Signature**

```gdscript
func show_dialog(state: bool, existing: BriefData = null) -> void
```

- **state**: True shows dialog, false hides it.
- **existing**: Optional briefing data to edit.

## Description

Open/close the dialog. If `existing` is null -> create mode.

## Source

```gdscript
func show_dialog(state: bool, existing: BriefData = null) -> void:
	if not state:
		visible = false
		working = null
		_reset_ui()
		return

	if existing:
		dialog_mode = DialogMode.EDIT
		working = existing.duplicate(true) as BriefData
	else:
		dialog_mode = DialogMode.CREATE
		working = BriefData.new()
		working.frag_objectives = []

	_load_from_working()
	visible = true
```
