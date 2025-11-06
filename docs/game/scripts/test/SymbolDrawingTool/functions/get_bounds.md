# SymbolDrawingTool::get_bounds Function Reference

*Defined at:* `scripts/test/SymbolDrawingTool.gd` (lines 513–519)</br>
*Belongs to:* [SymbolDrawingTool](../../SymbolDrawingTool.md)

**Signature**

```gdscript
func get_bounds() -> Rect2
```

## Source

```gdscript
	func get_bounds() -> Rect2:
		var min_x: float = min(start.x, end.x)
		var max_x: float = max(start.x, end.x)
		var min_y: float = min(start.y, end.y)
		var max_y: float = max(start.y, end.y)
		return Rect2(min_x, min_y, max_x - min_x, max_y - min_y)
```
