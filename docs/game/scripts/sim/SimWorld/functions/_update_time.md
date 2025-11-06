# SimWorld::_update_time Function Reference

*Defined at:* `scripts/sim/SimWorld.gd` (lines 391–394)</br>
*Belongs to:* [SimWorld](../../SimWorld.md)

**Signature**

```gdscript
func _update_time(dt: float) -> void
```

## Description

Advance world time

## Source

```gdscript
func _update_time(dt: float) -> void:
	environment_controller.tick(dt)
```
