# EnvBehaviorSystem::_weather_loss_factor Function Reference

*Defined at:* `scripts/sim/systems/EnvBehaviorSystem.gd` (lines 302–308)</br>
*Belongs to:* [EnvBehaviorSystem](../../EnvBehaviorSystem.md)

**Signature**

```gdscript
func _weather_loss_factor(scenario: Variant) -> float
```

## Description

Weather severity influence on loss risk.

## Source

```gdscript
func _weather_loss_factor(scenario: Variant) -> float:
	if visibility_profile == null:
		return 1.0
	var sev := visibility_profile.weather_severity_from_scenario(scenario)
	return clamp(1.0 + sev * 0.5, 0.5, 1.5)
```
