# TerrainRender::_set_data Function Reference

*Defined at:* `scripts/terrain/TerrainRender.gd` (lines 159–177)</br>
*Belongs to:* [TerrainRender](../../TerrainRender.md)

**Signature**

```gdscript
func _set_data(d: TerrainData)
```

## Description

Set new Terrain Data

## Source

```gdscript
func _set_data(d: TerrainData):
	data = d
	if data:
		data.changed.connect(_on_data_changed, CONNECT_DEFERRED | CONNECT_REFERENCE_COUNTED)
		clear_render_error()
		# Calculate scaled margins based on map size if margin_percent is set
		_calculate_scaled_margins()
		if path_grid:
			path_grid.data = data
			if nav_auto_build:
				path_grid.rebuild(nav_default_profile)
	else:
		render_error("NO TERRAIN DATA")
	call_deferred("_draw_map_size")
	call_deferred("_push_data_to_layers")
	call_deferred("_mark_all_dirty")
	call_deferred("_emit_render_ready")
```
