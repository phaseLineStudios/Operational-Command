# UnitData::_ensure_ammunition_from_equipment Function Reference

*Defined at:* `scripts/data/UnitData.gd` (lines 494–533)</br>
*Belongs to:* [UnitData](../../UnitData.md)

**Signature**

```gdscript
func _ensure_ammunition_from_equipment() -> void
```

## Description

Builds ammunition dictionaries based on equipped weapons when values are missing.

## Source

```gdscript
func _ensure_ammunition_from_equipment() -> void:
	var weapons := _get_equipment_category("weapons")
	if weapons.is_empty():
		return

	var ammo_caps: Dictionary = {}
	for weapon_name in weapons.keys():
		var entry_variant: Variant = weapons[weapon_name]
		if typeof(entry_variant) != TYPE_DICTIONARY:
			continue
		var weapon_entry: Dictionary = entry_variant
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
		ammo_caps[ammo_key] = int(ammo_caps.get(ammo_key, 0)) + qty

	if ammo_caps.is_empty():
		return

	if typeof(ammunition) != TYPE_DICTIONARY or ammunition == null:
		ammunition = {}
	if typeof(state_ammunition) != TYPE_DICTIONARY or state_ammunition == null:
		state_ammunition = {}

	for ammo_key in ammo_caps.keys():
		if not ammunition.has(ammo_key):
			ammunition[ammo_key] = ammo_caps[ammo_key]
		if not state_ammunition.has(ammo_key):
			state_ammunition[ammo_key] = ammo_caps[ammo_key]
```
