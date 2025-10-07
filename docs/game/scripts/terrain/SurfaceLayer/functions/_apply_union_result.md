# SurfaceLayer::_apply_union_result Function Reference

*Defined at:* `scripts/terrain/SurfaceLayer.gd` (lines 364–377)</br>
*Belongs to:* [SurfaceLayer](../../SurfaceLayer.md)

**Signature**

```gdscript
func _apply_union_result(key: String, merged: Array, ver: int) -> void
```

## Description

Applies a finished union result to the group if still up-to-date

## Source

```gdscript
func _apply_union_result(key: String, merged: Array, ver: int) -> void:
	if int(_pending_ver.get(key, 0)) != ver:
		_join_and_clear_thread(key)
		return
	if not _groups.has(key):
		_join_and_clear_thread(key)
		return
	_groups[key].merged = merged
	_groups[key].dirty = false
	_join_and_clear_thread(key)
	emit_signal("batches_rebuilt")
	queue_redraw()
```
