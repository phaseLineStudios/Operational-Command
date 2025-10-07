# SurfaceLayer::_join_and_clear_thread Function Reference

*Defined at:* `scripts/terrain/SurfaceLayer.gd` (lines 379–387)</br>
*Belongs to:* [SurfaceLayer](../../SurfaceLayer.md)

**Signature**

```gdscript
func _join_and_clear_thread(key: String) -> void
```

## Description

Joins the worker thread for a group (if running) and clears it

## Source

```gdscript
func _join_and_clear_thread(key: String) -> void:
	if _threads.has(key):
		var th: Thread = _threads[key]
		if th:
			if th.is_started():
				th.wait_to_finish()
			_threads.erase(key)
```
