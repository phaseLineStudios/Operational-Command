# UnitData::_is_anti_vehicle_ammo Function Reference

*Defined at:* `scripts/data/UnitData.gd` (lines 452–457)</br>
*Belongs to:* [UnitData](../../UnitData.md)

**Signature**

```gdscript
func _is_anti_vehicle_ammo(ammo_type: int) -> bool
```

## Description

Helper to classify a weapon ammo enum index as anti-vehicle capable.

## Source

```gdscript
func _is_anti_vehicle_ammo(ammo_type: int) -> bool:
	if ammo_type < 0:
		return false
	return _ANTI_VEHICLE_AMMO_TYPES.has(ammo_type)
```
