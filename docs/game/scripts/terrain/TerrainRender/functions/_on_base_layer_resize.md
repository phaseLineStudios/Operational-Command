# TerrainRender::_on_base_layer_resize Function Reference

*Defined at:* `scripts/terrain/TerrainRender.gd` (lines 312–315)</br>
*Belongs to:* [TerrainRender](../../TerrainRender.md)

**Signature**

```gdscript
func _on_base_layer_resize()
```

## Description

Emit a resize event for base layer

## Source

```gdscript
func _on_base_layer_resize():
	emit_signal("map_resize")
```
