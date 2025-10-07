# AmmoSystem::_within_radius Function Reference

*Defined at:* `scripts/sim/systems/AmmoSystem.gd` (lines 142–149)</br>
*Belongs to:* [AmmoSystem](../../AmmoSystem.md)

**Signature**

```gdscript
func _within_radius(src: UnitData, dst: UnitData) -> bool
```

## Description

True if src is within its transfer radius of dst.

## Source

```gdscript
func _within_radius(src: UnitData, dst: UnitData) -> bool:
	if not _positions.has(src.id) or not _positions.has(dst.id):
		return false
	var a: Vector3 = _positions[src.id]
	var b: Vector3 = _positions[dst.id]
	return a.distance_to(b) <= max(src.supply_transfer_radius_m, 0.0)
```
