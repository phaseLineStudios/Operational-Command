# SymbolDrawingTool::_set_tool Function Reference

*Defined at:* `scripts/test/SymbolDrawingTool.gd` (lines 66–82)</br>
*Belongs to:* [SymbolDrawingTool](../../SymbolDrawingTool.md)

**Signature**

```gdscript
func _set_tool(tool: ShapeType) -> void
```

## Description

Set current drawing tool

## Source

```gdscript
func _set_tool(tool: ShapeType) -> void:
	_current_tool = tool
	_selected_shape = null

	# Update button states
	line_btn.button_pressed = (tool == ShapeType.LINE)
	circle_btn.button_pressed = (tool == ShapeType.CIRCLE)
	ellipse_btn.button_pressed = (tool == ShapeType.ELLIPSE)
	rect_btn.button_pressed = (tool == ShapeType.RECTANGLE)

	# Show/hide corner radius for rectangles
	corner_slider.visible = (tool == ShapeType.RECTANGLE)
	corner_label.visible = (tool == ShapeType.RECTANGLE)

	canvas.queue_redraw()
```
