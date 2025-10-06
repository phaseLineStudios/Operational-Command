# LabelLayer::_notification Function Reference

*Defined at:* `scripts/terrain/LabelLayer.gd` (lines 98–102)</br>
*Belongs to:* [LabelLayer](../LabelLayer.md)

**Signature**

```gdscript
func _notification(what)
```

## Description

Redraw on resize so strokes match current Control rect

## Source

```gdscript
func _notification(what):
	if what == NOTIFICATION_RESIZED:
		queue_redraw()
```
