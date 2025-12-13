# EnvironmentController::set_rain_intensity Function Reference

*Defined at:* `scripts/sim/EnvironmentController.gd` (lines 279–282)</br>
*Belongs to:* [EnvironmentController](../../EnvironmentController.md)

**Signature**

```gdscript
func set_rain_intensity(intensity_mm_h: float) -> void
```

- **intensity_mm_h**: Rainfall in millimeters per hour (0.0 - 50.0)

## Description

Set rain intensity and update particle effects

## Source

```gdscript
func set_rain_intensity(intensity_mm_h: float) -> void:
	rain_intensity = intensity_mm_h
```
