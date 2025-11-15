# AmmoSystem::_is_logistics Function Reference

*Defined at:* `scripts/sim/systems/AmmoSystem.gd` (lines 157–171)</br>
*Belongs to:* [AmmoSystem](../../AmmoSystem.md)

**Signature**

```gdscript
func _is_logistics(u: UnitData) -> bool
```

## Description

True if the unit should act as a logistics source.

## Source

```gdscript
func _is_logistics(u: UnitData) -> bool:
	if u.throughput is Dictionary and not u.throughput.is_empty():
		return true
	if (
		u.equipment_tags is Array
		and (
			u.equipment_tags.has("AMMO_PALLET")
			or u.equipment_tags.has("AMMUNITION_PALLET")
			or u.equipment_tags.has("LOGISTICS")
		)
	):
		return true
	return false
```
