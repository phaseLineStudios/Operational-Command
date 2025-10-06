# LineLayer::_notification Function Reference

*Defined at:* `scripts/terrain/LineLayer.gd` (lines 72–76)</br>
*Belongs to:* [LineLayer](../LineLayer.md)

**Signature**

```gdscript
func _notification(what)
```

## Description

Redraw on resize so strokes match current Control rect.

## Source

```gdscript
func _notification(what):
	if what == NOTIFICATION_RESIZED:
		queue_redraw()
```
