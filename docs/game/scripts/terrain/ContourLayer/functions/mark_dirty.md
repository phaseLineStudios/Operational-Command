# ContourLayer::mark_dirty Function Reference

*Defined at:* `scripts/terrain/ContourLayer.gd` (lines 116–120)</br>
*Belongs to:* [ContourLayer](../ContourLayer.md)

**Signature**

```gdscript
func mark_dirty() -> void
```

## Description

API to request contour rebuild

## Source

```gdscript
func mark_dirty() -> void:
	_dirty = true
	_schedule_rebuild()
```
