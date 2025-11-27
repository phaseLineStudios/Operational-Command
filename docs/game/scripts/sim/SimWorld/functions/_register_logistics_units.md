# SimWorld::_register_logistics_units Function Reference

*Defined at:* `scripts/sim/SimWorld.gd` (lines 723–748)</br>
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

	if artillery_controller:
		artillery_controller.bind_ammo_system(ammo_system)
		if los_adapter:
			artillery_controller.bind_los_adapter(los_adapter)
		for su: ScenarioUnit in _friendlies + _enemies:
			artillery_controller.register_unit(su.id, su.unit)
			artillery_controller.set_unit_position(su.id, su.position_m)

	if engineer_controller:
		engineer_controller.bind_ammo_system(ammo_system)
		for su: ScenarioUnit in _friendlies + _enemies:
			engineer_controller.register_unit(su.id, su.unit)
			engineer_controller.set_unit_position(su.id, su.position_m)
```
