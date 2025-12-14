# EnvironmentController::get_weather Function Reference

*Defined at:* `scripts/sim/EnvironmentController.gd` (lines 443–449)</br>
*Belongs to:* [EnvironmentController](../../EnvironmentController.md)

**Signature**

```gdscript
func get_weather() -> Dictionary
```

- **Return Value**: Dictionary with keys: rain_mm_h, fog_visibility_m, wind_speed_m_s, wind_direction_deg

## Description

Get all current weather parameters

## Source

```gdscript
func get_weather() -> Dictionary:
	return {
		"rain_mm_h": rain_intensity,
		"fog_visibility_m": fog_visibility,
		"wind_speed_m_s": wind_speed,
		"wind_direction_deg": wind_direction
	}
```
