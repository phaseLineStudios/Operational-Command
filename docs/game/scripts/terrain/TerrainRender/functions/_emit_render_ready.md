# TerrainRender::_emit_render_ready Function Reference

*Defined at:* `scripts/terrain/TerrainRender.gd` (lines 214–222)</br>
*Belongs to:* [TerrainRender](../../TerrainRender.md)

**Signature**

```gdscript
func _emit_render_ready() -> void
```

## Description

Emit render_ready signal after waiting for layers to draw

## Source

```gdscript
func _emit_render_ready() -> void:
	if not is_inside_tree():
		return

	await get_tree().process_frame
	await get_tree().process_frame
	render_ready.emit()
```
