# SymbolDrawingTool::is_point_near Function Reference

*Defined at:* `scripts/test/SymbolDrawingTool.gd` (lines 520–522)</br>
*Belongs to:* [SymbolDrawingTool](../../SymbolDrawingTool.md)

**Signature**

```gdscript
func is_point_near(pos: Vector2, threshold := 8.0) -> bool
```

## Source

```gdscript
	func is_point_near(pos: Vector2, threshold := 8.0) -> bool:
		var bounds := get_bounds()
		return bounds.grow(threshold).has_point(pos)
```
