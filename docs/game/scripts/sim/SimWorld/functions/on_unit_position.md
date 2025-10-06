# SimWorld::on_unit_position Function Reference

*Defined at:* `scripts/sim/SimWorld.gd` (lines 46–47)</br>
*Belongs to:* [SimWorld](../SimWorld.md)

**Signature**

```gdscript
func on_unit_position(uid: String, pos: Vector3) -> void
```

## Description

Movement hook: call from movement/controller code whenever a unit moves.
`pos` is world-space (meters). For 2D maps, use Vector3(x, 0, y).

## Source

```gdscript
func on_unit_position(uid: String, pos: Vector3) -> void:
	_ammo.set_unit_position(uid, pos)
```
