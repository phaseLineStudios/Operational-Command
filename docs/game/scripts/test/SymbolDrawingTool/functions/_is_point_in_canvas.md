# SymbolDrawingTool::_is_point_in_canvas Function Reference

*Defined at:* `scripts/test/SymbolDrawingTool.gd` (lines 109–112)</br>
*Belongs to:* [SymbolDrawingTool](../../SymbolDrawingTool.md)

**Signature**

```gdscript
func _is_point_in_canvas(pos: Vector2) -> bool
```

## Description

Check if point is within canvas bounds

## Source

```gdscript
func _is_point_in_canvas(pos: Vector2) -> bool:
	return pos.x >= 0 and pos.x < CANVAS_SIZE and pos.y >= 0 and pos.y < CANVAS_SIZE
```
