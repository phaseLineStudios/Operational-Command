# SimWorld::_physics_process Function Reference

*Defined at:* `scripts/sim/SimWorld.gd` (lines 40–43)</br>
*Belongs to:* [SimWorld](../SimWorld.md)

**Signature**

```gdscript
func _physics_process(delta: float) -> void
```

## Description

Drive AmmoSystem every frame so in-field resupply progresses over time.

## Source

```gdscript
func _physics_process(delta: float) -> void:
	_ammo.tick(delta)
```
