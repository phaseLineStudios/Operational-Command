# MapController::_queue_viewport_update Function Reference

*Defined at:* `scripts/core/MapController.gd` (lines 263–269)</br>
*Belongs to:* [MapController](../../MapController.md)

**Signature**

```gdscript
func _queue_viewport_update() -> void
```

## Description

Schedule a one-shot render of the TerrainViewport (coalesced).

## Source

```gdscript
func _queue_viewport_update() -> void:
	if _viewport_update_queued or terrain_viewport == null:
		return
	_viewport_update_queued = true
	call_deferred("_do_viewport_update_once")
```
