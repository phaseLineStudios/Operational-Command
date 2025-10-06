# AmmoSystem::get_unit Function Reference

*Defined at:* `scripts/sim/systems/AmmoSystem.gd` (lines 66–69)</br>
*Belongs to:* [AmmoSystem](../AmmoSystem.md)

**Signature**

```gdscript
func get_unit(unit_id: String) -> UnitData
```

## Description

Retrieve the UnitData previously registered (or null if unknown).

## Source

```gdscript
func get_unit(unit_id: String) -> UnitData:
	return _units.get(unit_id, null)
```
