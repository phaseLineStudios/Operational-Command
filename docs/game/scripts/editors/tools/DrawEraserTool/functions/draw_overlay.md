# DrawEraserTool::draw_overlay Function Reference

*Defined at:* `scripts/editors/tools/ScenarioDrawEraserTool.gd` (lines 61–65)</br>
*Belongs to:* [DrawEraserTool](../../DrawEraserTool.md)

**Signature**

```gdscript
func draw_overlay(canvas: Control) -> void
```

- **canvas**: Overlay control.

## Description

Draw overlay preview (eraser cursor).

## Source

```gdscript
func draw_overlay(canvas: Control) -> void:
	canvas.draw_circle(_mouse_pos_px, cursor_radius_px, cursor_color)
	canvas.draw_arc(_mouse_pos_px, cursor_radius_px, 0.0, TAU, 32, Color.WHITE, 2.0, true)
```
