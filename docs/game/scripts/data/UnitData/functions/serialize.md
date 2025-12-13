# UnitData::serialize Function Reference

*Defined at:* `scripts/data/UnitData.gd` (lines 208–245)</br>
*Belongs to:* [UnitData](../../UnitData.md)

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
		"role": role,
		"allowed_slots": allowed_slots.duplicate(),
		"cost": cost,
		"size": int(size),
		"type": int(type),
		"strength": strength,
		"is_engineer": is_engineer,
		"is_medical": is_medical,
		"equipment": equipment.duplicate(),
		"experience": experience,
		"stats":
		{
			"attack": attack,
			"defense": defense,
			"spot_m": spot_m,
			"range_m": range_m,
			"morale": morale,
			"speed_kph": speed_kph,
			"understrength_threshold": understrength_threshold
		},
		"editor": {"unit_category": unit_category.id},
		"throughput": throughput.duplicate(),
		"equipment_tags": equipment_tags.duplicate(),
		"movement_profile": int(movement_profile),
		"doctrine": doctrine,
		# --- Ammo + Logistics persistence ---
		"ammunition": ammunition.duplicate(),
		"ammunition_low_threshold": ammunition_low_threshold,
		"ammunition_critical_threshold": ammunition_critical_threshold,
		"supply_transfer_rate": supply_transfer_rate,
		"supply_transfer_radius_m": supply_transfer_radius_m,
	}
```
