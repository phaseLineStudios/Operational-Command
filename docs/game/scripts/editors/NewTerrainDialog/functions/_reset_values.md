# NewTerrainDialog::_reset_values Function Reference

*Defined at:* `scripts/editors/TerrainSettingsDialog.gd` (lines 139–151)</br>
*Belongs to:* [NewTerrainDialog](../../NewTerrainDialog.md)

**Signature**

```gdscript
func _reset_values()
```

## Description

Reset values before popup (only when hiding)

## Source

```gdscript
func _reset_values():
	terrain_title.text = ""
	terrain_size_x.value = 2000
	terrain_size_y.value = 2000
	terrain_grid_x.value = 100
	terrain_grid_y.value = 100
	base_elevation.value = 110
	meta_country.text = ""
	meta_edition.text = ""
	meta_series.text = ""
	meta_sheet.text = ""
```
