# TerrainLineTool::_pick_point Function Reference

*Defined at:* `scripts/editors/tools/TerrainLineTool.gd` (lines 375–391)</br>
*Belongs to:* [TerrainLineTool](../../TerrainLineTool.md)

**Signature**

```gdscript
func _pick_point(pos: Vector2) -> int
```

## Source

```gdscript
func _pick_point(pos: Vector2) -> int:
	var terrain_pos = editor.map_to_terrain(pos)
	if _edit_idx < 0:
		return -1
	var pts := _current_points()
	if pts.is_empty():
		return -1
	var best := -1
	var best_d2 := _pick_radius_px * _pick_radius_px
	for i in pts.size():
		var d2 := pts[i].distance_squared_to(terrain_pos)
		if d2 <= best_d2:
			best = i
			best_d2 = d2
	return best
```
