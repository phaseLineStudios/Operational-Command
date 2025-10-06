# LineLayer::mark_dirty Function Reference

*Defined at:* `scripts/terrain/LineLayer.gd` (lines 39–45)</br>
*Belongs to:* [LineLayer](../LineLayer.md)

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
	_strokes.clear()
	_strokes_dirty = true
	queue_redraw()
```
