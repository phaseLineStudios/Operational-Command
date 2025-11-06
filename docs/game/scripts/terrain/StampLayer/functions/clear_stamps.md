# StampLayer::clear_stamps Function Reference

*Defined at:* `scripts/terrain/StampLayer.gd` (lines 34–39)</br>
*Belongs to:* [StampLayer](../../StampLayer.md)

**Signature**

```gdscript
func clear_stamps() -> void
```

## Description

Clear all stamps.

## Source

```gdscript
func clear_stamps() -> void:
	_stamps.clear()
	_texture_cache.clear()
	queue_redraw()
```
