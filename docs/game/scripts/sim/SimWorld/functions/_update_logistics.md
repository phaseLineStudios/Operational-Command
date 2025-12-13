# SimWorld::_update_logistics Function Reference

*Defined at:* `scripts/sim/SimWorld.gd` (lines 365–384)</br>
*Belongs to:* [SimWorld](../../SimWorld.md)

**Signature**

```gdscript
func _update_logistics(dt: float) -> void
```

- **dt**: Step delta seconds.

## Description

Ticks logistics systems and updates positions for proximity logic.

## Source

```gdscript
func _update_logistics(dt: float) -> void:
	if ammo_system:
		for su: ScenarioUnit in _friendlies + _enemies:
			ammo_system.set_unit_position(su.id, _v3_from_m(su.position_m))
		ammo_system.tick(dt)

	if fuel_system:
		fuel_system.tick(dt)

	if artillery_controller:
		for su: ScenarioUnit in _friendlies + _enemies:
			artillery_controller.set_unit_position(su.id, su.position_m)
		artillery_controller.tick(dt)

	if engineer_controller:
		for su: ScenarioUnit in _friendlies + _enemies:
			engineer_controller.set_unit_position(su.id, su.position_m)
		engineer_controller.tick(dt)
```
