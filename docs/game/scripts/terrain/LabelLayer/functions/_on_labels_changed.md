# LabelLayer::_on_labels_changed Function Reference

*Defined at:* `scripts/terrain/LabelLayer.gd` (lines 73–96)</br>
*Belongs to:* [LabelLayer](../../LabelLayer.md)

**Signature**

```gdscript
func _on_labels_changed(kind: String, ids: PackedInt32Array)
```

## Description

Handles TerrainData label mutations and marks affected labels dirty

## Source

```gdscript
func _on_labels_changed(kind: String, ids: PackedInt32Array):
	match kind:
		"reset":
			_items.clear()
			_draw_dirty = true
		"added":
			for id in ids:
				_upsert_from_data(id)
		"removed":
			for id in ids:
				_items.erase(id)
			_draw_dirty = true
		"move":
			for id in ids:
				_refresh_pose_only(id)
		"style", "meta":
			for id in ids:
				_upsert_from_data(id)
		_:
			_items.clear()
			_draw_dirty = true
	queue_redraw()
```
