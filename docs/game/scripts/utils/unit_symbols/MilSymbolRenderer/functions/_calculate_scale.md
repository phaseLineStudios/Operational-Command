# MilSymbolRenderer::_calculate_scale Function Reference

*Defined at:* `scripts/utils/unit_symbols/MilSymbolRenderer.gd` (lines 47–52)</br>
*Belongs to:* [MilSymbolRenderer](../../MilSymbolRenderer.md)

**Signature**

```gdscript
func _calculate_scale() -> void
```

## Description

Calculate scale factor to fit symbol into configured size

## Source

```gdscript
func _calculate_scale() -> void:
	var target_size: float = config.get_pixel_size()
	# Account for resolution scaling - if rendering at higher res, scale up proportionally
	scale_factor = (target_size * config.resolution_scale) / MilSymbolConfig.BASE_SIZE
```
