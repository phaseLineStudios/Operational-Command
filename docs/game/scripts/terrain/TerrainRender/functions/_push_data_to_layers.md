# TerrainRender::_push_data_to_layers Function Reference

*Defined at:* `scripts/terrain/TerrainRender.gd` (lines 152–178)</br>
*Belongs to:* [TerrainRender](../TerrainRender.md)

**Signature**

```gdscript
func _push_data_to_layers() -> void
```

## Description

Push exports to their respective layers

## Source

```gdscript
func _push_data_to_layers() -> void:
	if grid_layer:
		grid_layer.set_data(data)
		grid_layer.apply_style(self)

	if margin:
		margin.set_data(data)
		margin.apply_style(self)

	if contour_layer:
		contour_layer.set_data(data)
		contour_layer.apply_style(self)

	if surface_layer:
		surface_layer.set_data(data)

	if line_layer:
		line_layer.set_data(data)

	if point_layer:
		point_layer.set_data(data)

	if label_layer:
		label_layer.set_data(data)
		label_layer.apply_style(self)
```
