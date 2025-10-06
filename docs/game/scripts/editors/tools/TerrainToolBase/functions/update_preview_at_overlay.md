# TerrainToolBase::update_preview_at_overlay Function Reference

*Defined at:* `scripts/editors/tools/TerrainToolBase.gd` (lines 84–97)</br>
*Belongs to:* [TerrainToolBase](../TerrainToolBase.md)

**Signature**

```gdscript
func update_preview_at_overlay(overlay: Control, overlay_pos: Vector2) -> void
```

## Description

Update preview location on viewport

## Source

```gdscript
func update_preview_at_overlay(overlay: Control, overlay_pos: Vector2) -> void:
	if not _preview or not render:
		return
	var overlay_to_canvas := overlay.get_global_transform_with_canvas()
	var canvas_pos := overlay_to_canvas * overlay_pos

	var canvas_to_overlay := overlay_to_canvas.affine_inverse()
	var overlay_local := canvas_to_overlay * canvas_pos
	if _preview is Control:
		(_preview as Control).position = overlay_local
		_place_preview(overlay_pos)
		_preview.queue_redraw()
```
