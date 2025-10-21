# LabelLayer::mark_dirty Function Reference

*Defined at:* `scripts/terrain/LabelLayer.gd` (lines 65–71)</br>
*Belongs to:* [LabelLayer](../../LabelLayer.md)

**Signature**

```gdscript
func mark_dirty()
```

## Description

Marks the whole layer as dirty and queues a redraw (forces full rebuild)

## Source

```gdscript
func mark_dirty():
	_items.clear()
	_draw_items.clear()
	_draw_dirty = true
	queue_redraw()
```
