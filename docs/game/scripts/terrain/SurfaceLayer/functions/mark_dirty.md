# SurfaceLayer::mark_dirty Function Reference

*Defined at:* `scripts/terrain/SurfaceLayer.gd` (lines 61–65)</br>
*Belongs to:* [SurfaceLayer](../../SurfaceLayer.md)

**Signature**

```gdscript
func mark_dirty() -> void
```

## Description

Marks the whole layer as dirty and queues a redraw (forces full rebuild)

## Source

```gdscript
func mark_dirty() -> void:
	_dirty_all = true
	queue_redraw()
```
