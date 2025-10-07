# MarginLayer::mark_dirty Function Reference

*Defined at:* `scripts/terrain/MapMargin.gd` (lines 101–105)</br>
*Belongs to:* [MarginLayer](../../MarginLayer.md)

**Signature**

```gdscript
func mark_dirty()
```

## Description

Mark dirty for redraw

## Source

```gdscript
func mark_dirty():
	_dirty = true
	queue_redraw()
```
