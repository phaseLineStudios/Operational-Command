# TerrainRender::_mark_all_dirty Function Reference

*Defined at:* `scripts/terrain/TerrainRender.gd` (lines 239–256)</br>
*Belongs to:* [TerrainRender](../../TerrainRender.md)

**Signature**

```gdscript
func _mark_all_dirty() -> void
```

## Description

Mark elements as dirty to redraw

## Source

```gdscript
func _mark_all_dirty() -> void:
	if grid_layer:
		grid_layer.mark_dirty()
	if margin:
		margin.mark_dirty()
	if contour_layer:
		contour_layer.mark_dirty()
	if surface_layer:
		surface_layer.mark_dirty()
	if line_layer:
		line_layer.mark_dirty()
	if point_layer:
		point_layer.mark_dirty()
	if label_layer:
		label_layer.mark_dirty()
	queue_redraw()
```
