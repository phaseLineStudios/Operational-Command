# UnitCreateDialog::show_dialog Function Reference

*Defined at:* `scripts/editors/UnitCreateDialog.gd` (lines 104–115)</br>
*Belongs to:* [UnitCreateDialog](../../UnitCreateDialog.md)

**Signature**

```gdscript
func show_dialog(state: bool, unit: UnitData = null) -> void
```

- **state**: True to show, false to hide.
- **unit**: Optional, if supplied will edit that unit.

## Description

Open dialog (CREATE if unit == null).

## Source

```gdscript
func show_dialog(state: bool, unit: UnitData = null) -> void:
	if not state:
		hide()
		_reset_ui()
		return
	_reset_ui()
	_mode = DialogMode.EDIT if unit != null else DialogMode.CREATE
	_working = (unit.duplicate(true) as UnitData) if unit != null else UnitData.new()
	_load_from_working()
	popup_centered_ratio(0.72)
```
