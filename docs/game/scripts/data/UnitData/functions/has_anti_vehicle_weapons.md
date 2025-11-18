# UnitData::has_anti_vehicle_weapons Function Reference

*Defined at:* `scripts/data/UnitData.gd` (lines 439–450)</br>
*Belongs to:* [UnitData](../../UnitData.md)

**Signature**

```gdscript
func has_anti_vehicle_weapons() -> bool
```

## Description

Returns true when the equipment loadout includes anti-vehicle weapons.

## Source

```gdscript
func has_anti_vehicle_weapons() -> bool:
	var weapons: Dictionary = _get_equipment_category("weapons")
	for weapon_name in weapons.keys():
		var weapon_data: Variant = weapons[weapon_name]
		if typeof(weapon_data) != TYPE_DICTIONARY:
			continue
		var weapon_entry: Dictionary = weapon_data
		if _is_anti_vehicle_ammo(_resolve_ammo_index(weapon_entry.get("ammo", -1))):
			return true
	return false
```
