# TerrainLabelTool::_place_preview Function Reference

*Defined at:* `scripts/editors/tools/TerrainLabelTool.gd` (lines 29–36)</br>
*Belongs to:* [TerrainLabelTool](../TerrainLabelTool.md)

**Signature**

```gdscript
func _place_preview(local_px: Vector2) -> void
```

## Source

```gdscript
func _place_preview(local_px: Vector2) -> void:
	if _preview == null:
		return
	_preview.position = local_px
	_preview.visible = true
	_preview.queue_redraw()
```
