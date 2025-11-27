# UnitData::get_weapon_ammo_types Function Reference

*Defined at:* `scripts/data/UnitData.gd` (lines 415–437)</br>
*Belongs to:* [UnitData](../../UnitData.md)

**Signature**

```gdscript
func get_weapon_ammo_types() -> Dictionary
```

## Description

Returns the ammo types referenced by the unit's weapon equipment.

## Source

```gdscript
func get_weapon_ammo_types() -> Dictionary:
	var result: Dictionary = {}
	var weapons: Dictionary = _get_equipment_category("weapons")
	for weapon_name in weapons.keys():
		var weapon_data: Variant = weapons[weapon_name]
		if typeof(weapon_data) != TYPE_DICTIONARY:
			continue
		var weapon_entry: Dictionary = weapon_data
		var ammo_idx := _resolve_ammo_index(weapon_entry.get("ammo", -1))
		if ammo_idx < 0:
			continue
		var ammo_key := _ammo_index_to_key(ammo_idx)
		if ammo_key == "":
			continue
		var qty: int = int(
			weapon_entry.get("type", weapon_entry.get("count", weapon_entry.get("quantity", 1)))
		)
		if qty <= 0:
			qty = 1
		result[ammo_key] = int(result.get(ammo_key, 0)) + qty
	return result
```
