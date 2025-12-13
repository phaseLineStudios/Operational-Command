# EnvBehaviorSystem::_random_drift Function Reference

*Defined at:* `scripts/sim/systems/EnvBehaviorSystem.gd` (lines 238–243)</br>
*Belongs to:* [EnvBehaviorSystem](../../EnvBehaviorSystem.md)

**Signature**

```gdscript
func _random_drift(rng: RandomNumberGenerator) -> Vector2
```

## Description

Generate a small drift vector used while a unit is lost.

## Source

```gdscript
func _random_drift(rng: RandomNumberGenerator) -> Vector2:
	var angle: float = rng.randf_range(0.0, PI * 2.0)
	var magnitude: float = rng.randf_range(0.5, 2.0)
	return Vector2.RIGHT.rotated(angle) * magnitude
```
