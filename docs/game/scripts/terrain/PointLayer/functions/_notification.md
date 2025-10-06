# PointLayer::_notification Function Reference

*Defined at:* `scripts/terrain/PointLayer.gd` (lines 72–76)</br>
*Belongs to:* [PointLayer](../PointLayer.md)

**Signature**

```gdscript
func _notification(what)
```

## Description

Redraw on resize so points match current Control rect.

## Source

```gdscript
func _notification(what):
	if what == NOTIFICATION_RESIZED:
		queue_redraw()
```
