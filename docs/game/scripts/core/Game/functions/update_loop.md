# Game::update_loop Function Reference

*Defined at:* `scripts/core/Game.gd` (lines 86–90)</br>
*Belongs to:* [Game](../../Game.md)

**Signature**

```gdscript
func update_loop(dt: float) -> void
```

## Description

Call from mission tick.

## Source

```gdscript
func update_loop(dt: float) -> void:
	if is_instance_valid(resolution):
		resolution.tick(dt)
```
