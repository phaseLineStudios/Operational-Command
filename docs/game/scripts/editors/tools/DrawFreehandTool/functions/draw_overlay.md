# DrawFreehandTool::draw_overlay Function Reference

*Defined at:* `scripts/editors/tools/ScenarioDrawFreehandTool.gd` (lines 83–94)</br>
*Belongs to:* [DrawFreehandTool](../../DrawFreehandTool.md)

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
	if _points_m.is_empty():
		return
	var pts_px := PackedVector2Array()
	for p_m in _points_m:
		pts_px.push_back(editor.ctx.terrain_render.terrain_to_map(p_m))
	var col := color
	col.a *= opacity
	for i in range(1, pts_px.size()):
		canvas.draw_line(pts_px[i - 1], pts_px[i], col, width_px, true)
```
