# ContourLayer::_get_base_offset Function Reference

*Defined at:* `scripts/terrain/ContourLayer.gd` (lines 505–508)</br>
*Belongs to:* [ContourLayer](../ContourLayer.md)

**Signature**

```gdscript
func _get_base_offset() -> float
```

## Description

Get base elevation offset

## Source

```gdscript
func _get_base_offset() -> float:
	return data.base_elevation_m if (data and "base_elevation_m" in data) else 0
```
