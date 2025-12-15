# EnvironmentController::_update_weather_cloud_coverage Function Reference

*Defined at:* `scripts/sim/EnvironmentController.gd` (lines 408–421)</br>
*Belongs to:* [EnvironmentController](../../EnvironmentController.md)

**Signature**

```gdscript
func _update_weather_cloud_coverage() -> void
```

## Description

Internal: Update cloud coverage based on weather conditions

## Source

```gdscript
func _update_weather_cloud_coverage() -> void:
	var rain_cloud_coverage: float = 1.0
	_set_cloud_coverage = max(cloud_coverage, rain_cloud_coverage)

	if rain_intensity > 0.0:
		_cloud_brightness_modifier = remap(rain_intensity, 0.0, 50.0, 1.0, 0.3)
		_sky_brightness_modifier = remap(rain_intensity, 0.0, 50.0, 1.0, 0.15)
		_light_power_modifier = remap(rain_intensity, 0.0, 50.0, 1.0, 0.35)
	else:
		_cloud_brightness_modifier = 1.0
		_sky_brightness_modifier = 1.0
		_light_power_modifier = 1.0
```
