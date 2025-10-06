# NewTerrainDialog::_on_primary_pressed Function Reference

*Defined at:* `scripts/editors/TerrainSettingsDialog.gd` (lines 60–89)</br>
*Belongs to:* [NewTerrainDialog](../NewTerrainDialog.md)

**Signature**

```gdscript
func _on_primary_pressed()
```

## Source

```gdscript
func _on_primary_pressed():
	var sx := int(terrain_size_x.value)
	var sy := int(terrain_size_y.value)
	if sx <= 0 or sy <= 0:
		push_warning("Terrain size must be > 0.")
		return

	if _is_edit_mode and _target_data != null:
		_target_data.name = terrain_title.text
		_target_data.width_m = sx
		_target_data.height_m = sy
		_target_data.grid_start_x = int(terrain_grid_x.value)
		_target_data.grid_start_y = int(terrain_grid_y.value)
		_target_data.base_elevation_m = int(base_elevation.value)

		show_dialog(false)
		emit_signal("request_edit", _target_data)
	else:
		var data := TerrainData.new()
		data.name = terrain_title.text
		data.width_m = sx
		data.height_m = sy
		data.grid_start_x = int(terrain_grid_x.value)
		data.grid_start_y = int(terrain_grid_y.value)
		data.base_elevation_m = int(base_elevation.value)

		show_dialog(false)
		emit_signal("request_create", data)
```
