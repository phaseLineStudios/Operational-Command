# TerrainToolBase::_place_preview Function Reference

*Defined at:* `scripts/editors/tools/TerrainToolBase.gd` (lines 99–104)</br>
*Belongs to:* [TerrainToolBase](../TerrainToolBase.md)

**Signature**

```gdscript
func _place_preview(local_px: Vector2) -> void
```

## Description

Where to place the preview and how to feed parameters

## Source

```gdscript
func _place_preview(local_px: Vector2) -> void:
	if _preview is Control:
		(_preview as Control).position = local_px
		_preview.queue_redraw()
```
