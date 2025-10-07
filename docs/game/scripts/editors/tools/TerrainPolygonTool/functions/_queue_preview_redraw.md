# TerrainPolygonTool::_queue_preview_redraw Function Reference

*Defined at:* `scripts/editors/tools/TerrainPolygonTool.gd` (lines 388–392)</br>
*Belongs to:* [TerrainPolygonTool](../../TerrainPolygonTool.md)

**Signature**

```gdscript
func _queue_preview_redraw() -> void
```

## Description

Queue a redraw of the preview

## Source

```gdscript
func _queue_preview_redraw() -> void:
	if _preview:
		_preview.queue_redraw()
```
