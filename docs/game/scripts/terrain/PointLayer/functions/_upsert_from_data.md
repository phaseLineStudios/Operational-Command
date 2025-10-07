# PointLayer::_upsert_from_data Function Reference

*Defined at:* `scripts/terrain/PointLayer.gd` (lines 106–162)</br>
*Belongs to:* [PointLayer](../../PointLayer.md)

**Signature**

```gdscript
func _upsert_from_data(id: int, rebuild_all: bool) -> void
```

## Description

Insert/update a point by id, recomputing size/tex/visibility as needed

## Source

```gdscript
func _upsert_from_data(id: int, rebuild_all: bool) -> void:
	var point: Variant = _find_point_by_id(id)
	if point == null:
		_items.erase(id)
		_draw_dirty = true
		return

	var brush: TerrainBrush = point.get("brush", null)
	if brush == null or brush.feature_type != TerrainBrush.FeatureType.POINT:
		_items.erase(id)
		_draw_dirty = true
		return

	var tex: Texture2D = brush.symbol
	if tex == null:
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
	var p_size: float = brush.symbol_size_m * max(0.01, p_scale)

	var p_visible := _is_terrain_pos_visible(pos)

	var it: Dictionary = _items.get(
		id,
		{
			"pos": Vector2.ZERO,
			"rot": 0.0,
			"scale": 1.0,
			"size": p_size,
			"tex": tex,
			"z": int(brush.z_index),
			"visible": p_visible
		}
	)

	it.pos = pos
	it.rot = rot
	it.scale = p_scale
	it.size = p_size
	if rebuild_all:
		it.tex = tex
		it.z = int(brush.z_index)
	it.visible = p_visible

	_items[id] = it
	_draw_dirty = true
```
