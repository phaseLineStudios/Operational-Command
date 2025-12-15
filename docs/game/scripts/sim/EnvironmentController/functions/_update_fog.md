# EnvironmentController::_update_fog Function Reference

*Defined at:* `scripts/sim/EnvironmentController.gd` (lines 350–389)</br>
*Belongs to:* [EnvironmentController](../../EnvironmentController.md)

**Signature**

```gdscript
func _update_fog() -> void
```

## Description

Internal: Update fog density based on visibility distance

## Source

```gdscript
func _update_fog() -> void:
	if environment == null:
		return

	var visibility_fog_density := 0.0

	if fog_visibility_curve != null:
		var normalized_visibility: float = clamp(fog_visibility / 10000.0, 0.0, 1.0)
		visibility_fog_density = fog_visibility_curve.sample(normalized_visibility)
	else:
		if fog_visibility < 50.0:
			visibility_fog_density = remap(fog_visibility, 0.0, 50.0, 0.30, 0.20)
		elif fog_visibility < 200.0:
			visibility_fog_density = remap(fog_visibility, 50.0, 200.0, 0.20, 0.10)
		elif fog_visibility < 500.0:
			visibility_fog_density = remap(fog_visibility, 200.0, 500.0, 0.10, 0.05)
		elif fog_visibility < 1000.0:
			visibility_fog_density = remap(fog_visibility, 500.0, 1000.0, 0.05, 0.02)
		elif fog_visibility < 2000.0:
			visibility_fog_density = remap(fog_visibility, 1000.0, 2000.0, 0.02, 0.008)
		elif fog_visibility < 4000.0:
			visibility_fog_density = remap(fog_visibility, 2000.0, 4000.0, 0.008, 0.002)
		elif fog_visibility < 10000.0:
			visibility_fog_density = remap(fog_visibility, 4000.0, 10000.0, 0.002, 0.0)
		else:
			visibility_fog_density = 0.0

	var rain_fog_density := 0.0
	if rain_intensity > 0.0:
		rain_fog_density = remap(rain_intensity, 0.0, 50.0, 0.0, 0.15)

	var fog_density: float = max(visibility_fog_density, rain_fog_density)
	fog_density = clamp(fog_density, 0.0, 0.30)

	environment.volumetric_fog_enabled = fog_density > 0.0
	environment.volumetric_fog_density = fog_density

	environment.fog_enabled = false
```
