# TerrainBrush::los_attenuation_for_length Function Reference

*Defined at:* `scripts/terrain/TerrainBrush.gd` (lines 103–106)</br>
*Belongs to:* [TerrainBrush](../TerrainBrush.md)

**Signature**

```gdscript
func los_attenuation_for_length(length_m: float) -> float
```

## Description

Returns cumulative LOS attenuation for a ray marching `length_m`.

## Source

```gdscript
func los_attenuation_for_length(length_m: float) -> float:
	return clamp(los_attenuation_per_m * max(length_m, 0.0), 0.0, 1.0)
```
