# SurfaceLayer::_rebuild_dirty_groups Function Reference

*Defined at:* `scripts/terrain/SurfaceLayer.gd` (lines 200–211)</br>
*Belongs to:* [SurfaceLayer](../../SurfaceLayer.md)

**Signature**

```gdscript
func _rebuild_dirty_groups() -> void
```

## Description

Starts asynchronous unions for any groups currently marked dirty

## Source

```gdscript
func _rebuild_dirty_groups() -> void:
	var kicked_any := false
	for key in _groups.keys():
		var group = _groups[key]
		if not group.dirty:
			continue
		_start_union_thread(key)
		kicked_any = true
	if kicked_any:
		pass
```
