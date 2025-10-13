# TerrainPolygonTool::_place_preview Function Reference

*Defined at:* `scripts/editors/tools/TerrainPolygonTool.gd` (lines 103–107)</br>
*Belongs to:* [TerrainPolygonTool](../../TerrainPolygonTool.md)

**Signature**

```gdscript
func _place_preview(_local_px: Vector2) -> void
```

## Source

```gdscript
func _place_preview(_local_px: Vector2) -> void:
	if _preview:
		_preview.queue_redraw()
```
