# ContourLayer::_on_data_changed Function Reference

*Defined at:* `scripts/terrain/ContourLayer.gd` (lines 128–131)</br>
*Belongs to:* [ContourLayer](../../ContourLayer.md)

**Signature**

```gdscript
func _on_data_changed() -> void
```

## Description

Rebuild contours if terrain data changes

## Source

```gdscript
func _on_data_changed() -> void:
	mark_dirty()
```
