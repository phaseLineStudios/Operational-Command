# TerrainRender::render_error Function Reference

*Defined at:* `scripts/terrain/TerrainRender.gd` (lines 194–200)</br>
*Belongs to:* [TerrainRender](../../TerrainRender.md)

**Signature**

```gdscript
func render_error(error: String = "") -> void
```

## Description

Show a render error

## Source

```gdscript
func render_error(error: String = "") -> void:
	if error_layer == null:
		return
	error_layer.visible = true
	error_label.text = error
```
