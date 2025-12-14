# AmmoSystem::_is_logistics Function Reference

*Defined at:* `scripts/sim/systems/AmmoSystem.gd` (lines 165–179)</br>
*Belongs to:* [AmmoSystem](../../AmmoSystem.md)

**Signature**

```gdscript
func _is_logistics(su: ScenarioUnit) -> bool
```

## Description

True if the unit should act as a logistics source.

## Source

```gdscript
func _is_logistics(su: ScenarioUnit) -> bool:
	if su.unit.throughput is Dictionary and not su.unit.throughput.is_empty():
		return true
	if (
		su.unit.equipment_tags is Array
		and (
			su.unit.equipment_tags.has("AMMO_PALLET")
			or su.unit.equipment_tags.has("AMMUNITION_PALLET")
			or su.unit.equipment_tags.has("LOGISTICS")
		)
	):
		return true
	return false
```
