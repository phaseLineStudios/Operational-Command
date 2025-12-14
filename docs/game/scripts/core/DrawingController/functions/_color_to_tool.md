# DrawingController::_color_to_tool Function Reference

*Defined at:* `scripts/core/DrawingController.gd` (lines 449–463)</br>
*Belongs to:* [DrawingController](../../DrawingController.md)

**Signature**

```gdscript
func _color_to_tool(color: Color) -> Tool
```

- **color**: Stroke color.
- **Return Value**: Tool enum value.

## Description

Convert color to closest drawing tool.

## Source

```gdscript
func _color_to_tool(color: Color) -> Tool:
	var r := color.r
	var g := color.g
	var b := color.b

	if r < 0.3 and g < 0.3 and b < 0.3:
		return Tool.PEN_BLACK

	if b > 0.5 and r < 0.5:
		return Tool.PEN_BLUE

	if r > 0.5 and b < 0.5:
		return Tool.PEN_RED

	return Tool.PEN_BLACK
```
