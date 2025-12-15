# EnvironmentController::set_wind Function Reference

*Defined at:* `scripts/sim/EnvironmentController.gd` (lines 296–300)</br>
*Belongs to:* [EnvironmentController](../../EnvironmentController.md)

**Signature**

```gdscript
func set_wind(speed_m_s: float, direction_deg: float) -> void
```

- **speed_m_s**: Wind speed in meters per second (0.0 - 110.0)
- **direction_deg**: Wind azimuth direction in degrees (0.0 - 360.0)

## Description

Set wind parameters
0° = North, 90° = East, 180° = South, 270° = West

## Source

```gdscript
func set_wind(speed_m_s: float, direction_deg: float) -> void:
	wind_speed = speed_m_s
	wind_direction = direction_deg
```
