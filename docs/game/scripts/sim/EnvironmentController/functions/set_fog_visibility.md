# EnvironmentController::set_fog_visibility Function Reference

*Defined at:* `scripts/sim/EnvironmentController.gd` (lines 288–291)</br>
*Belongs to:* [EnvironmentController](../../EnvironmentController.md)

**Signature**

```gdscript
func set_fog_visibility(visibility_m: float) -> void
```

- **visibility_m**: Visibility distance in meters (0.0 - 10000.0)

## Description

Set fog visibility distance
Lower values = denser fog

## Source

```gdscript
func set_fog_visibility(visibility_m: float) -> void:
	fog_visibility = visibility_m
```
