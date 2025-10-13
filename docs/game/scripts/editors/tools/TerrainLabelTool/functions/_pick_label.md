# TerrainLabelTool::_pick_label Function Reference

*Defined at:* `scripts/editors/tools/TerrainLabelTool.gd` (lines 205–226)</br>
*Belongs to:* [TerrainLabelTool](../../TerrainLabelTool.md)

**Signature**

```gdscript
func _pick_label(mouse_global: Vector2) -> int
```

## Source

```gdscript
func _pick_label(mouse_global: Vector2) -> int:
	if data == null or data.labels == null:
		return -1
	var size := label_size
	var best := -1
	var best_d2 := _pick_radius_px * _pick_radius_px

	for i in data.labels.size():
		var s = data.labels[i]
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
