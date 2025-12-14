# FuelSystem::_is_tanker Function Reference

*Defined at:* `scripts/sim/systems/FuelSystem.gd` (lines 321–334)</br>
*Belongs to:* [FuelSystem](../../FuelSystem.md)

**Signature**

```gdscript
func _is_tanker(u: UnitData) -> bool
```

## Description

Refuel logic

## Source

```gdscript
func _is_tanker(u: UnitData) -> bool:
	## A unit acts as a tanker if it has a positive throughput["fuel"] or a logistics tag.
	if u == null:
		return false
	if u.throughput is Dictionary and int(u.throughput.get("fuel", 0)) > 0:
		return true
	if (
		u.equipment_tags is Array
		and (u.equipment_tags.has("FUEL_TANKER") or u.equipment_tags.has("LOGISTICS"))
	):
		return true
	return false
```
