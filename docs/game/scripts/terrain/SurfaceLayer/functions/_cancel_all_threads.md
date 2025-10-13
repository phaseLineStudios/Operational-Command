# SurfaceLayer::_cancel_all_threads Function Reference

*Defined at:* `scripts/terrain/SurfaceLayer.gd` (lines 389–395)</br>
*Belongs to:* [SurfaceLayer](../../SurfaceLayer.md)

**Signature**

```gdscript
func _cancel_all_threads() -> void
```

## Description

Cancels and clears all worker threads and pending versions

## Source

```gdscript
func _cancel_all_threads() -> void:
	for key in _threads.keys():
		_join_and_clear_thread(key)
	_threads.clear()
	_pending_ver.clear()
```
