# UnitData::compute_attack_power Function Reference

*Defined at:* `scripts/data/UnitData.gd` (lines 352–378)</br>
*Belongs to:* [UnitData](../../UnitData.md)

**Signature**

```gdscript
func compute_attack_power(ammo_damage_config: AmmoDamageConfig = null) -> float
```

## Description

Calculates the attack rating using equipment, ammo profiles, and strength.

## Source

```gdscript
func compute_attack_power(ammo_damage_config: AmmoDamageConfig = null) -> float:
	_ensure_ammunition_from_equipment()
	var weapons: Dictionary = _get_equipment_category("weapons")
	var total_weapon_power: float = 0.0
	for weapon_name in weapons.keys():
		var weapon_data: Variant = weapons[weapon_name]
		if typeof(weapon_data) != TYPE_DICTIONARY:
			continue
		var weapon_entry: Dictionary = weapon_data
		total_weapon_power += _compute_weapon_attack_value(weapon_entry, ammo_damage_config)

	var effective_strength: float = state_strength
	if effective_strength <= 0.0:
		effective_strength = float(strength)
	effective_strength = max(effective_strength, 0.0)

	if float(strength) > 0.0:
		var ratio: float = clamp(effective_strength / float(strength), 0.0, 1.25)
		total_weapon_power *= ratio

	# Always give personnel a baseline small-arms contribution so support units aren't helpless.
	var manpower_component: float = effective_strength * _BASE_PERSONNEL_DAMAGE_PER_SOLDIER
	var computed: float = max(total_weapon_power + manpower_component, 0.0)
	attack = computed
	return computed
```
