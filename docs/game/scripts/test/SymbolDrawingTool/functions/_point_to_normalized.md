# SymbolDrawingTool::_point_to_normalized Function Reference

*Defined at:* `scripts/test/SymbolDrawingTool.gd` (lines 473–478)</br>
*Belongs to:* [SymbolDrawingTool](../../SymbolDrawingTool.md)

**Signature**

```gdscript
func _point_to_normalized(point: Vector2, canvas_center: Vector2) -> Vector2
```

## Description

Convert canvas point to normalized offset from center

## Source

```gdscript
func _point_to_normalized(point: Vector2, canvas_center: Vector2) -> Vector2:
	var offset := point - canvas_center
	# Scale to icon size
	return offset / (ICON_AREA / 2.0)
```
