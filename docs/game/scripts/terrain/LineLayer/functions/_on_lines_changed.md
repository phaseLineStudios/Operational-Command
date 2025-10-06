# LineLayer::_on_lines_changed Function Reference

*Defined at:* `scripts/terrain/LineLayer.gd` (lines 47–70)</br>
*Belongs to:* [LineLayer](../LineLayer.md)

**Signature**

```gdscript
func _on_lines_changed(kind: String, ids: PackedInt32Array) -> void
```

## Description

Handles TerrainData line mutations and marks affected lines dirty

## Source

```gdscript
func _on_lines_changed(kind: String, ids: PackedInt32Array) -> void:
	match kind:
		"reset":
			_items.clear()
			_strokes_dirty = true
		"added":
			for id in ids:
				_upsert_from_data(id, true)
		"removed":
			for id in ids:
				_items.erase(id)
			_strokes_dirty = true
		"points":
			for id in ids:
				_refresh_geometry(id)
		"style", "brush", "meta":
			for id in ids:
				_refresh_recipe_and_geometry(id)
		_:
			_items.clear()
			_strokes_dirty = true
	queue_redraw()
```
