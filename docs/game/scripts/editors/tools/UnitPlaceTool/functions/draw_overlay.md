# UnitPlaceTool::draw_overlay Function Reference

*Defined at:* `scripts/editors/tools/ScenarioUnitTool.gd` (lines 86–94)</br>
*Belongs to:* [UnitPlaceTool](../UnitPlaceTool.md)

**Signature**

```gdscript
func draw_overlay(canvas: Control) -> void
```

## Source

```gdscript
func draw_overlay(canvas: Control) -> void:
	if not _hover_valid or not _icon_tex:
		return
	var screen_pos := editor.ctx.terrain_render.terrain_to_map(_hover_map_pos)
	var size := Vector2(48, 48)
	var rect := Rect2(screen_pos - size * 0.5, size)
	canvas.draw_texture_rect(_icon_tex, rect, false)
```
