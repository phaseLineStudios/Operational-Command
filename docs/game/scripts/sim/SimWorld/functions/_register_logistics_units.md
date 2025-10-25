# SimWorld::_register_logistics_units Function Reference

*Defined at:* `scripts/sim/SimWorld.gd` (lines 465–476)</br>
*Belongs to:* [SimWorld](../../SimWorld.md)

**Signature**

```gdscript
func _register_logistics_units() -> void
```

## Description

Register all units with logistics systems and bind hooks.

## Source

```gdscript
func _register_logistics_units() -> void:
	if fuel_system:
		for su: ScenarioUnit in _friendlies + _enemies:
			fuel_system.register_scenario_unit(su)
			su.bind_fuel_system(fuel_system)

	if ammo_system:
		for su: ScenarioUnit in _friendlies + _enemies:
			ammo_system.register_unit(su.unit)
			ammo_system.set_unit_position(su.id, _v3_from_m(su.position_m))
```
