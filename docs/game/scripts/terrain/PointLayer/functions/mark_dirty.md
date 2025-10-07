# PointLayer::mark_dirty Function Reference

*Defined at:* `scripts/terrain/PointLayer.gd` (lines 39–45)</br>
*Belongs to:* [PointLayer](../../PointLayer.md)

**Signature**

```gdscript
func mark_dirty() -> void
```

## Description

Marks the whole layer as dirty and queues a redraw (forces full rebuild)

## Source

```gdscript
func mark_dirty() -> void:
	_items.clear()
	_draw_items.clear()
	_draw_dirty = true
	queue_redraw()
```
