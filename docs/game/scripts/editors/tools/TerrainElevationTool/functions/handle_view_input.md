# TerrainElevationTool::handle_view_input Function Reference

*Defined at:* `scripts/editors/tools/TerrainElevationTool.gd` (lines 107–149)</br>
*Belongs to:* [TerrainElevationTool](../../TerrainElevationTool.md)

**Signature**

```gdscript
func handle_view_input(event: InputEvent) -> bool
```

## Source

```gdscript
func handle_view_input(event: InputEvent) -> bool:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if not render.is_inside_terrain(event.position):
			return false

		if event.pressed:
			_is_drag = true
			_stroke_active = true
			_stroke_rect = Rect2i()
			_img_before = (
				data.elevation.duplicate()
				if data and data.elevation and not data.elevation.is_empty()
				else null
			)
			_apply(event.position)
		else:
			_is_drag = false
			if (
				_stroke_active
				and _img_before
				and _stroke_rect.size.x > 0
				and _stroke_rect.size.y > 0
			):
				var before_block := _block_from_image(_img_before, _stroke_rect)
				var after_block := data.get_elevation_block(_stroke_rect)
				if editor and editor.history:
					editor.history.push_elevation_patch(
						data, _stroke_rect, before_block, after_block, "Elevation stroke"
					)
			_stroke_active = false
			_img_before = null
			_stroke_rect = Rect2i()
		return true

	if _is_drag and event is InputEventMouseMotion:
		if not render.is_inside_terrain(event.position):
			return false
		_apply(event.position)
		return true

	return false
```
