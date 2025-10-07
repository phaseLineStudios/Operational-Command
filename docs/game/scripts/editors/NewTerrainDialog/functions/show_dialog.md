# NewTerrainDialog::show_dialog Function Reference

*Defined at:* `scripts/editors/TerrainSettingsDialog.gd` (lines 131–136)</br>
*Belongs to:* [NewTerrainDialog](../../NewTerrainDialog.md)

**Signature**

```gdscript
func show_dialog(state: bool)
```

## Description

Show/hide dialog

## Source

```gdscript
func show_dialog(state: bool):
	visible = state
	if not state:
		_is_edit_mode = false
		_target_data = null
		_reset_values()
```
