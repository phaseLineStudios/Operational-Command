# SurfaceLayer::_on_surfaces_changed Function Reference

*Defined at:* `scripts/terrain/SurfaceLayer.gd` (lines 67–88)</br>
*Belongs to:* [SurfaceLayer](../SurfaceLayer.md)

**Signature**

```gdscript
func _on_surfaces_changed(kind: String, ids: PackedInt32Array) -> void
```

## Description

Handles TerrainData surface mutations and marks affected groups dirty

## Source

```gdscript
func _on_surfaces_changed(kind: String, ids: PackedInt32Array) -> void:
	match kind:
		"reset":
			_dirty_all = true
		"added":
			for id in ids:
				_upsert_from_data(id, false)
		"removed":
			for id in ids:
				_remove_id(id)
		"points":
			for id in ids:
				_refresh_geometry_same_group(id)
		"brush", "meta":
			for id in ids:
				_move_if_key_changed(id)
		_:
			_dirty_all = true

	queue_redraw()
```
