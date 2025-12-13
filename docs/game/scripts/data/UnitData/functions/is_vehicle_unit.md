# UnitData::is_vehicle_unit Function Reference

*Defined at:* `scripts/data/UnitData.gd` (lines 424–457)</br>
*Belongs to:* [UnitData](../../UnitData.md)

**Signature**

```gdscript
func is_vehicle_unit() -> bool
```

## Description

Returns true when the unit should be treated as a vehicle target in combat.

## Source

```gdscript
func is_vehicle_unit() -> bool:
	var vehicles: Dictionary = _get_equipment_category("vehicles")
	for vehicle_name in vehicles.keys():
		var vehicle_entry: Variant = vehicles[vehicle_name]
		match typeof(vehicle_entry):
			TYPE_DICTIONARY:
				if int(vehicle_entry.get("type", vehicle_entry.get("count", 0))) > 0:
					return true
			TYPE_INT, TYPE_FLOAT:
				if int(vehicle_entry) > 0:
					return true
			_:
				continue

	match movement_profile:
		TerrainBrush.MoveProfile.TRACKED, TerrainBrush.MoveProfile.WHEELED:
			return true
		_:
			pass

	if (
		type
		in [MilSymbol.UnitType.ARMOR, MilSymbol.UnitType.MECHANIZED, MilSymbol.UnitType.MOTORIZED]
	):
		return true

	for slot in allowed_slots:
		var slot_str := String(slot).to_upper()
		if slot_str.find("ARMOR") != -1 or slot_str.find("MECH") != -1:
			return true

	return false
```
