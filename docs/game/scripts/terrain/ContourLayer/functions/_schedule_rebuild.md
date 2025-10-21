# ContourLayer::_schedule_rebuild Function Reference

*Defined at:* `scripts/terrain/ContourLayer.gd` (lines 139–153)</br>
*Belongs to:* [ContourLayer](../../ContourLayer.md)

**Signature**

```gdscript
func _schedule_rebuild() -> void
```

## Description

Schedule a Rebuild of the contour lines

## Source

```gdscript
func _schedule_rebuild() -> void:
	if _rebuild_scheduled:
		return
	_rebuild_scheduled = true
	var t := get_tree().create_timer(rebuild_delay_sec)
	t.timeout.connect(
		func():
			_rebuild_scheduled = false
			if not is_instance_valid(self):
				return
			_rebuild_contours()
			queue_redraw()
	)
```
