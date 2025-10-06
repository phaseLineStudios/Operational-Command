# TerrainPointTool::_get_minimum_size Function Reference

*Defined at:* `scripts/editors/tools/TerrainPointTool.gd` (lines 287–291)</br>
*Belongs to:* [TerrainPointTool](../TerrainPointTool.md)

**Signature**

```gdscript
func _get_minimum_size() -> Vector2
```

## Source

```gdscript
	func _get_minimum_size() -> Vector2:
		if tex == null:
			return Vector2.ZERO
		return Vector2(tex.get_width(), tex.get_height()) * max(0.01, scale_factor)
```
