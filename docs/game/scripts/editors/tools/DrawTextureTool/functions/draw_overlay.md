# DrawTextureTool::draw_overlay Function Reference

*Defined at:* `scripts/editors/tools/ScenarioDrawTextureTool.gd` (lines 79–91)</br>
*Belongs to:* [DrawTextureTool](../../DrawTextureTool.md)

**Signature**

```gdscript
func draw_overlay(canvas: Control) -> void
```

- **canvas**: Overlay control.

## Description

Draw overlay preview.

## Source

```gdscript
func draw_overlay(canvas: Control) -> void:
	if not texture or not _has_hover:
		return
	var pos_px := editor.ctx.terrain_render.terrain_to_map(_hover_m)
	var sz := texture.get_size() * scale * 0.1
	var col := Color(1, 1, 1, opacity)
	col *= color
	canvas.draw_set_transform(pos_px, deg_to_rad(rotation_deg))
	var rect := Rect2(-sz * 0.5, sz)
	canvas.draw_texture_rect(texture, rect, false, col)
	canvas.draw_set_transform(Vector2(0, 0))
```
