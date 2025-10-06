# PointLayer::_on_points_changed Function Reference

*Defined at:* `scripts/terrain/PointLayer.gd` (lines 47–70)</br>
*Belongs to:* [PointLayer](../PointLayer.md)

**Signature**

```gdscript
func _on_points_changed(kind: String, ids: PackedInt32Array) -> void
```

## Description

Handles TerrainData point mutations and marks affected points dirty

## Source

```gdscript
func _on_points_changed(kind: String, ids: PackedInt32Array) -> void:
	match kind:
		"reset":
			_items.clear()
			_draw_dirty = true
		"added":
			for id in ids:
				_upsert_from_data(id, true)
		"removed":
			for id in ids:
				_items.erase(id)
			_draw_dirty = true
		"move":
			for id in ids:
				_refresh_pose(id)
		"style", "brush", "meta":
			for id in ids:
				_upsert_from_data(id, true)
		_:
			_items.clear()
			_draw_dirty = true
	queue_redraw()
```
