# CombatController::_apply_vehicle_damage_resolution Function Reference

*Defined at:* `scripts/sim/Combat.gd` (lines 562–588)</br>
*Belongs to:* [CombatController](../../CombatController.md)

**Signature**

```gdscript
func _apply_vehicle_damage_resolution(attacker: ScenarioUnit, defender: ScenarioUnit, damage_value)
```

## Description

Applies vehicle-specific damage/destruction logic when applicable.

## Source

```gdscript
func _apply_vehicle_damage_resolution(attacker: ScenarioUnit, defender: ScenarioUnit, damage_value):
	if damage_value <= 0.0:
		return
	if not _is_vehicle_target(defender):
		return
	if not _attacker_can_damage_vehicle(attacker):
		return

	var vehicle_damage: float = damage_value
	if ammo_damage_config and attacker and attacker.unit:
		var weapon_ammo: Dictionary = attacker.unit.get_weapon_ammo_types()
		var highest_profile: float = 0.0
		for ammo_key in weapon_ammo.keys():
			highest_profile = max(
				highest_profile, ammo_damage_config.get_vehicle_damage_for(String(ammo_key))
			)
		if highest_profile > 0.0:
			vehicle_damage *= clamp(highest_profile * 0.05, 0.25, 3.0)

	var equipment_loss: float = clamp(vehicle_damage * 0.01, 0.0, 1.0)
	defender.state_equipment = max(defender.state_equipment - equipment_loss, 0.0)

	if defender.state_equipment <= 0.05:
		var catastrophic_loss: int = int(max(1.0, floor(vehicle_damage * 0.02)))
		_apply_casualties(defender, catastrophic_loss)
```
