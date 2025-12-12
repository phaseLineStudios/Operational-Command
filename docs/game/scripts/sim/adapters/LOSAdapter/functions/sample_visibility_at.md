# LOSAdapter::sample_visibility_at Function Reference

*Defined at:* `scripts/sim/adapters/LOSAdapter.gd` (lines 182–197)</br>
*Belongs to:* [LOSAdapter](../../LOSAdapter.md)

**Signature**

```gdscript
func sample_visibility_at(_pos_m: Vector2) -> float
```

## Description

Visibility sampling at a position placeholder.

## Source

```gdscript
func sample_visibility_at(_pos_m: Vector2) -> float:
	if _renderer == null:
		return 1.0
	# Derive a local concealment penalty by sampling spotting_mul at zero range,
	# then invert it to represent visibility (1.0 = clear, lower = obscured).
	var spot_mul: float = spotting_mul(_pos_m, 0.0, _current_weather_severity())
	var conceal_bonus: float = 1.0
	var surf: Dictionary = _renderer.get_surface_at_terrain_position(_pos_m)
	if typeof(surf) == TYPE_DICTIONARY and surf.has("brush"):
		var brush: Variant = surf.get("brush")
		if brush and brush.has_method("get"):
			var conceal: float = clamp(float(brush.get("concealment", 0.0)), 0.0, 1.0)
			conceal_bonus = max(0.05, 1.0 - conceal)
	return clamp(spot_mul * conceal_bonus, 0.0, 1.0)
```
