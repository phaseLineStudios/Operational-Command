# SimWorld::_v3_from_m Function Reference

*Defined at:* `scripts/sim/SimWorld.gd` (lines 635–638)</br>
*Belongs to:* [SimWorld](../../SimWorld.md)

**Signature**

```gdscript
func _v3_from_m(p_m: Vector2) -> Vector3
```

## Description

Current XZ position to 3D vector for systems needing 3D.

## Source

```gdscript
func _v3_from_m(p_m: Vector2) -> Vector3:
	return Vector3(p_m.x, 0.0, p_m.y)
```
