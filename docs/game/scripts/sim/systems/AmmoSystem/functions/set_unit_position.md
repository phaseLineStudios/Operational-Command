# AmmoSystem::set_unit_position Function Reference

*Defined at:* `scripts/sim/systems/AmmoSystem.gd` (lines 61–64)</br>
*Belongs to:* [AmmoSystem](../../AmmoSystem.md)

**Signature**

```gdscript
func set_unit_position(unit_id: String, pos: Vector3) -> void
```

## Description

Update a unit's world-space position (meters; XZ used, Y ignored).

## Source

```gdscript
func set_unit_position(unit_id: String, pos: Vector3) -> void:
	_positions[unit_id] = pos
```
