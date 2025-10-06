# MarginLayer::_notification Function Reference

*Defined at:* `scripts/terrain/MapMargin.gd` (lines 107–111)</br>
*Belongs to:* [MarginLayer](../MarginLayer.md)

**Signature**

```gdscript
func _notification(what)
```

## Description

Redraw margin on resize

## Source

```gdscript
func _notification(what):
	if what == NOTIFICATION_THEME_CHANGED or what == NOTIFICATION_RESIZED:
		queue_redraw()
```
