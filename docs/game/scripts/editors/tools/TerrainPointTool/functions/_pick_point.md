# TerrainPointTool::_pick_point Function Reference

*Defined at:* `scripts/editors/tools/TerrainPointTool.gd` (lines 248–267)</br>
*Belongs to:* [TerrainPointTool](../../TerrainPointTool.md)

**Signature**

```gdscript
func _pick_point(mouse_global: Vector2) -> int
```

## Source

```gdscript
func _pick_point(mouse_global: Vector2) -> int:
	if data == null or data.points == null:
		return -1
	var best := -1
	var best_d2 := _pick_radius_px * _pick_radius_px
	for i in data.points.size():
		var s = data.points[i]
		if typeof(s) != TYPE_DICTIONARY:
			continue
		var p_local: Vector2 = s.get("pos", Vector2.INF)
		if not p_local.is_finite():
			continue
		var p_map := editor.map_to_terrain(p_local)
		var d2 := p_map.distance_squared_to(mouse_global)
		if d2 <= best_d2:
			best = i
			best_d2 = d2
	return best
```
