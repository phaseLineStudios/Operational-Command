# PointLayer::_refresh_pose Function Reference

*Defined at:* `scripts/terrain/PointLayer.gd` (lines 164–191)</br>
*Belongs to:* [PointLayer](../../PointLayer.md)

**Signature**

```gdscript
func _refresh_pose(id: int) -> void
```

## Description

Update only pos/rot/scale/size/visibility

## Source

```gdscript
func _refresh_pose(id: int) -> void:
	if not _items.has(id):
		_upsert_from_data(id, false)
		return
	var point: Variant = _find_point_by_id(id)
	if point == null:
		_items.erase(id)
		_draw_dirty = true
		return
	var pos: Vector2 = point.get("pos", Vector2.INF)
	if not pos.is_finite():
		_items.erase(id)
		_draw_dirty = true
		return
	var rot: float = float(point.get("rot", 0.0))
	var p_scale: float = float(point.get("scale", 1.0))
	var brush: TerrainBrush = point.get("brush", null)
	var p_size: float = (brush.symbol_size_m if brush else 1.0) * max(0.01, p_scale)
	var it = _items[id]
	it.pos = pos
	it.rot = rot
	it.scale = p_scale
	it.size = p_size
	it.visible = _is_terrain_pos_visible(pos)
	_items[id] = it
	_draw_dirty = true
```
