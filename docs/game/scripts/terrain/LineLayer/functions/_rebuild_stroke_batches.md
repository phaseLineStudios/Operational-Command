# LineLayer::_rebuild_stroke_batches Function Reference

*Defined at:* `scripts/terrain/LineLayer.gd` (lines 205–257)</br>
*Belongs to:* [LineLayer](../../LineLayer.md)

**Signature**

```gdscript
func _rebuild_stroke_batches() -> void
```

## Description

Build stroke groups (outline/core) per identical state and sort by z

## Source

```gdscript
func _rebuild_stroke_batches() -> void:
	_strokes_dirty = false
	_strokes.clear()
	if _items.is_empty():
		return

	var groups: Dictionary = {}
	for id in _items.keys():
		var it = _items[id]
		var core_w: float = it.core_w
		var stroke_w: float = float(
			it.rec.stroke.width_px if it.rec.has("stroke") and "width_px" in it.rec.stroke else 1.0
		)
		var outline_w := core_w + 2.0 * stroke_w

		var chain_outline: PackedVector2Array = it.safe_pts
		var chain_core: PackedVector2Array = it.safe_pts
		if snap_half_px_for_thin_strokes and (int(round(outline_w)) % 2 != 0):
			chain_outline = _offset_half_px(chain_outline)
		if snap_half_px_for_thin_strokes and (int(round(core_w)) % 2 != 0):
			chain_core = _offset_half_px(chain_core)

		var key_out := _stroke_key(it.mode, it.stroke_col, outline_w, it.z, it.dash, it.gap)
		if not groups.has(key_out):
			groups[key_out] = {
				"mode": it.mode,
				"color": it.stroke_col,
				"width": outline_w,
				"chains": [],
				"z": it.z,
				"dash": it.dash,
				"gap": it.gap
			}
		groups[key_out].chains.append(chain_outline)

		var key_core := _stroke_key(it.mode, it.fill_col, core_w, it.z, it.dash, it.gap)
		if not groups.has(key_core):
			groups[key_core] = {
				"mode": it.mode,
				"color": it.fill_col,
				"width": core_w,
				"chains": [],
				"z": it.z,
				"dash": it.dash,
				"gap": it.gap
			}
		groups[key_core].chains.append(chain_core)

	for k in groups.keys():
		_strokes.append(groups[k])
	_strokes.sort_custom(func(a, b): return int(a.z) < int(b.z))
```
