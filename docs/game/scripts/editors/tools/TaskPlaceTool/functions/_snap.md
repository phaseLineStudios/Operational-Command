# TaskPlaceTool::_snap Function Reference

*Defined at:* `scripts/editors/tools/ScenarioTaskTool.gd` (lines 105–109)</br>
*Belongs to:* [TaskPlaceTool](../TaskPlaceTool.md)

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
