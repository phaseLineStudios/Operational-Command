# DrawingController::_get_tool_color Function Reference

*Defined at:* `scripts/core/DrawingController.gd` (lines 293–306)</br>
*Belongs to:* [DrawingController](../../DrawingController.md)

**Signature**

```gdscript
func _get_tool_color(tool: Tool) -> Color
```

## Source

```gdscript
func _get_tool_color(tool: Tool) -> Color:
	match tool:
		Tool.PEN_BLACK:
			return Color.BLACK
		Tool.PEN_BLUE:
			return Color.BLUE
		Tool.PEN_RED:
			return Color.RED
		Tool.ERASER:
			return Color.WHITE
		_:
			return Color.BLACK
```
