# ContourLayer::_notification Function Reference

*Defined at:* `scripts/terrain/ContourLayer.gd` (lines 122–126)</br>
*Belongs to:* [ContourLayer](../../ContourLayer.md)

**Signature**

```gdscript
func _notification(what)
```

## Description

Redraw contours on resize

## Source

```gdscript
func _notification(what):
	if what == NOTIFICATION_RESIZED:
		queue_redraw()
```
