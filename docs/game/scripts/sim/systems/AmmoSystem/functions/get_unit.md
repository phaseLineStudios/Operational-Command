# AmmoSystem::get_unit Function Reference

*Defined at:* `scripts/sim/systems/AmmoSystem.gd` (lines 74–77)</br>
*Belongs to:* [AmmoSystem](../../AmmoSystem.md)

**Signature**

```gdscript
func get_unit(unit_id: String) -> ScenarioUnit
```

## Description

Retrieve the ScenarioUnit previously registered (or null if unknown).

## Source

```gdscript
func get_unit(unit_id: String) -> ScenarioUnit:
	return _units.get(unit_id, null)
```
