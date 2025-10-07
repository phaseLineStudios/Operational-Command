# NewTerrainDialog::open_for_edit Function Reference

*Defined at:* `scripts/editors/TerrainSettingsDialog.gd` (lines 48–59)</br>
*Belongs to:* [NewTerrainDialog](../../NewTerrainDialog.md)

**Signature**

```gdscript
func open_for_edit(data: TerrainData) -> void
```

## Description

Open the dialog for editing an existing TerrainData

## Source

```gdscript
func open_for_edit(data: TerrainData) -> void:
	if data == null:
		push_warning("open_for_edit: no TerrainData provided; falling back to create mode.")
		open_for_create()
		return
	_is_edit_mode = true
	_target_data = data
	_window_title_and_cta()
	_fill_fields_from_data(data)
	show_dialog(true)
```
