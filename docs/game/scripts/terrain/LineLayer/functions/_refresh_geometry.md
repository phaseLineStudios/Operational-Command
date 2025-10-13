# LineLayer::_refresh_geometry Function Reference

*Defined at:* `scripts/terrain/LineLayer.gd` (lines 178–198)</br>
*Belongs to:* [LineLayer](../../LineLayer.md)

**Signature**

```gdscript
func _refresh_geometry(id: int) -> void
```

## Source

```gdscript
func _refresh_geometry(id: int) -> void:
	if not _items.has(id):
		_upsert_from_data(id, false)
		return
	var line: Variant = _find_line_by_id(id)
	if line == null:
		_items.erase(id)
		_strokes_dirty = true
		return
	var pts: PackedVector2Array = line.get("points", PackedVector2Array())
	if pts.size() < 2:
		_items.erase(id)
		_strokes_dirty = true
		return
	var it = _items[id]
	it.pts = pts
	it.safe_pts = renderer.clamp_shape_to_terrain(pts)
	_items[id] = it
	_strokes_dirty = true
```
