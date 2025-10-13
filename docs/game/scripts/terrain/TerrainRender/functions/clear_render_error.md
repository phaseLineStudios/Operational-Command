# TerrainRender::clear_render_error Function Reference

*Defined at:* `scripts/terrain/TerrainRender.gd` (lines 195–200)</br>
*Belongs to:* [TerrainRender](../../TerrainRender.md)

**Signature**

```gdscript
func clear_render_error() -> void
```

## Description

Hide the render error

## Source

```gdscript
func clear_render_error() -> void:
	if error_layer == null:
		return
	error_layer.visible = false
```
