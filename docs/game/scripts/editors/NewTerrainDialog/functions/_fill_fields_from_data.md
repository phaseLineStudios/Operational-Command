# NewTerrainDialog::_fill_fields_from_data Function Reference

*Defined at:* `scripts/editors/TerrainSettingsDialog.gd` (lines 120–132)</br>
*Belongs to:* [NewTerrainDialog](../../NewTerrainDialog.md)

**Signature**

```gdscript
func _fill_fields_from_data(data: TerrainData) -> void
```

## Source

```gdscript
func _fill_fields_from_data(data: TerrainData) -> void:
	terrain_title.text = data.name
	terrain_size_x.value = int(data.width_m)
	terrain_size_y.value = int(data.height_m)
	terrain_grid_x.value = int(data.grid_start_x)
	terrain_grid_y.value = int(data.grid_start_y)
	base_elevation.value = float(data.base_elevation_m)
	meta_country.text = data.country
	meta_edition.text = data.edition
	meta_series.text = data.series
	meta_sheet.text = data.sheet
```
