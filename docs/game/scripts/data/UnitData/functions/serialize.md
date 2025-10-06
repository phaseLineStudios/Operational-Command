# UnitData::serialize Function Reference

*Defined at:* `scripts/data/UnitData.gd` (lines 92–134)</br>
*Belongs to:* [UnitData](../UnitData.md)

**Signature**

```gdscript
func serialize() -> Dictionary
```

## Description

Serialize this unit to JSON

## Source

```gdscript
func serialize() -> Dictionary:
	return {
		"id": id,
		"title": title,
		"icon_path":
		icon.resource_path as Variant if icon and icon.resource_path != "" else null as Variant,
		"role": role,
		"allowed_slots": allowed_slots.duplicate(),
		"cost": cost,
		"size": int(size),
		"strength": strength,
		"equipment": equipment.duplicate(),
		"experience": experience,
		"stats":
		{
			"attack": attack,
			"defense": defense,
			"spot_m": spot_m,
			"range_m": range_m,
			"morale": morale,
			"speed_kph": speed_kph
		},
		"state":
		{
			"state_strength": state_strength,
			"state_injured": state_injured,
			"state_equipment": state_equipment,
			"cohesion": cohesion
		},
		"editor": {"unit_category": unit_category.id},
		"throughput": throughput.duplicate(),
		"equipment_tags": equipment_tags.duplicate(),
		"doctrine": doctrine,
		# --- Ammo + Logistics persistence ---
		"ammunition": ammunition.duplicate(),
		"state_ammunition": state_ammunition.duplicate(),
		"ammunition_low_threshold": ammunition_low_threshold,
		"ammunition_critical_threshold": ammunition_critical_threshold,
		"supply_transfer_rate": supply_transfer_rate,
		"supply_transfer_radius_m": supply_transfer_radius_m,
	}
```
