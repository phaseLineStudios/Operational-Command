# UnitPlaceTool::_snap Function Reference

*Defined at:* `scripts/editors/tools/ScenarioUnitTool.gd` (lines 110–114)</br>
*Belongs to:* [UnitPlaceTool](../../UnitPlaceTool.md)

**Signature**

```gdscript
func _snap(p: Vector2) -> Vector2
```

## Source

```gdscript
func _snap(p: Vector2) -> Vector2:
	var s := 100.0
	return Vector2(round(p.x / s) * s, round(p.y / s) * s)
```
