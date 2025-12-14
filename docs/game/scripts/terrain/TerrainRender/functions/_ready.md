# TerrainRender::_ready Function Reference

*Defined at:* `scripts/terrain/TerrainRender.gd` (lines 134–147)</br>
*Belongs to:* [TerrainRender](../../TerrainRender.md)

**Signature**

```gdscript
func _ready()
```

## Source

```gdscript
func _ready():
	_apply_base_style_if_needed()
	_draw_map_size()
	base_layer.resized.connect(_on_base_layer_resize)

	if not data:
		render_error("NO TERRAIN DATA")

	if data and path_grid:
		path_grid.data = data
		if nav_auto_build:
			path_grid.rebuild(nav_default_profile)
```
