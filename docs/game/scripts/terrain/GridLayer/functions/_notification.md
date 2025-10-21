# GridLayer::_notification Function Reference

*Defined at:* `scripts/terrain/GridLayer.gd` (lines 41–46)</br>
*Belongs to:* [GridLayer](../../GridLayer.md)

**Signature**

```gdscript
func _notification(what)
```

## Source

```gdscript
func _notification(what):
	if what == NOTIFICATION_RESIZED:
		_need_bake = true
		queue_redraw()
```
