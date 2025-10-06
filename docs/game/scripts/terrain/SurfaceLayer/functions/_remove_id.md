# SurfaceLayer::_remove_id Function Reference

*Defined at:* `scripts/terrain/SurfaceLayer.gd` (lines 248–260)</br>
*Belongs to:* [SurfaceLayer](../SurfaceLayer.md)

**Signature**

```gdscript
func _remove_id(id: int) -> void
```

## Description

Removes a surface by id and marks its group dirty

## Source

```gdscript
func _remove_id(id: int) -> void:
	var key: Variant = _id_to_key.get(id, null)
	if key == null:
		return
	_id_to_key.erase(id)
	if not _groups.has(key):
		return
	_groups[key].polys.erase(id)
	_groups[key].bboxes.erase(id)
	_groups[key].dirty = true
	_start_union_thread(key)
```
