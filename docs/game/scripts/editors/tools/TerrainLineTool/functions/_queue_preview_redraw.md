# TerrainLineTool::_queue_preview_redraw Function Reference

*Defined at:* `scripts/editors/tools/TerrainLineTool.gd` (lines 62–66)</br>
*Belongs to:* [TerrainLineTool](../../TerrainLineTool.md)

**Signature**

```gdscript
func _queue_preview_redraw() -> void
```

## Source

```gdscript
func _queue_preview_redraw() -> void:
	if _preview:
		_preview.queue_redraw()
```
