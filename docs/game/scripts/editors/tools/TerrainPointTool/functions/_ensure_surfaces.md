# TerrainPointTool::_ensure_surfaces Function Reference

*Defined at:* `scripts/editors/tools/TerrainPointTool.gd` (lines 204–210)</br>
*Belongs to:* [TerrainPointTool](../../TerrainPointTool.md)

**Signature**

```gdscript
func _ensure_surfaces()
```

## Source

```gdscript
func _ensure_surfaces():
	if data == null:
		return
	if !("surfaces" in data) or data.points == null:
		data.points = []
```
