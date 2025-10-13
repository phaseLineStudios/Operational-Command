# LabelLayer::_refresh_pose_only Function Reference

*Defined at:* `scripts/terrain/LabelLayer.gd` (lines 161–183)</br>
*Belongs to:* [LabelLayer](../../LabelLayer.md)

**Signature**

```gdscript
func _refresh_pose_only(id: int) -> void
```

## Description

Update position/rotation only (fast path for drags)

## Source

```gdscript
func _refresh_pose_only(id: int) -> void:
	if not _items.has(id):
		_upsert_from_data(id)
		return
	var l: Variant = _find_label_by_id(id)
	if l == null:
		_items.erase(id)
		_draw_dirty = true
		return
	var pos: Vector2 = l.get("pos", Vector2.INF)
	if not pos.is_finite():
		_items.erase(id)
		_draw_dirty = true
		return
	var rot: float = float(l.get("rot", 0.0))
	var it = _items[id]
	it.pos = pos
	it.rot = rot
	it.visible = _is_terrain_pos_visible(pos)
	_items[id] = it
	_draw_dirty = true
```
