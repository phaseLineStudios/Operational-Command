# FuelSystem::_terrain_slope_multiplier Function Reference

*Defined at:* `scripts/sim/systems/FuelSystem.gd` (lines 236–258)</br>
*Belongs to:* [FuelSystem](../../FuelSystem.md)

**Signature**

```gdscript
func _terrain_slope_multiplier(a: Vector2, b: Vector2) -> float
```

## Description

Terrain and slope

## Source

```gdscript
func _terrain_slope_multiplier(a: Vector2, b: Vector2) -> float:
	## Combine surface and slope multipliers. Returns 1.0 if no terrain data is provided.
	if terrain_data == null:
		return 1.0
	var surface_mult: float = 1.0
	var slope_mult: float = 1.0

	# Surface multiplier from terrain areas
	var surfaces: Array = terrain_data.surfaces
	if surfaces != null and surfaces.size() > 0:
		var mid: Vector2 = (a + b) * 0.5
		surface_mult = _surface_mult_at(mid)

	# Slope multiplier from elevation texture
	var img: Image = terrain_data.elevation
	if img != null and not img.is_empty():
		var k: float = fuel_profile.slope_k if fuel_profile != null else 0.25
		var dz_norm: float = _elevation_delta_norm(a, b)
		slope_mult = 1.0 + max(0.0, k) * clamp(dz_norm, 0.0, 1.0)

	return max(0.1, surface_mult * slope_mult)
```
