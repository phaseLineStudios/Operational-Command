# TerrainLineTool::_current_points Function Reference

*Defined at:* `scripts/editors/tools/TerrainLineTool.gd` (lines 323–331)</br>
*Belongs to:* [TerrainLineTool](../../TerrainLineTool.md)

**Signature**

```gdscript
func _current_points() -> PackedVector2Array
```

## Source

```gdscript
func _current_points() -> PackedVector2Array:
	if data == null:
		return PackedVector2Array()
	var idx := _ensure_current_line_idx()
	if idx < 0:
		return PackedVector2Array()
	return data.lines[idx].get("points", PackedVector2Array())
```
