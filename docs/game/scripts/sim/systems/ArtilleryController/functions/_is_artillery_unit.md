# ArtilleryController::_is_artillery_unit Function Reference

*Defined at:* `scripts/sim/systems/ArtilleryController.gd` (lines 410–423)</br>
*Belongs to:* [ArtilleryController](../../ArtilleryController.md)

**Signature**

```gdscript
func _is_artillery_unit(su: ScenarioUnit) -> bool
```

## Description

Check if unit has artillery/mortar ammunition

## Source

```gdscript
func _is_artillery_unit(su: ScenarioUnit) -> bool:
	if not su.unit.equipment or not su.unit.equipment.has("weapons"):
		return false

	var weapons: Dictionary = su.unit.equipment.get("weapons", {})
	for weapon_name in weapons.keys():
		var weapon_data: Dictionary = weapons[weapon_name]
		var ammo_type_index: int = int(weapon_data.get("ammo", -1))

		# Check if ammo type is mortar or artillery (indices 6-11)
		if ammo_type_index >= 6 and ammo_type_index <= 11:
			return true

	return false
```
