# TerrainLineTool::_place_preview Function Reference

*Defined at:* `scripts/editors/tools/TerrainLineTool.gd` (lines 53–57)</br>
*Belongs to:* [TerrainLineTool](../../TerrainLineTool.md)

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
