# AmmoDamageConfig::get_vehicle_damage_for Function Reference

*Defined at:* `scripts/data/AmmoDamageConfig.gd` (lines 25–28)</br>
*Belongs to:* [AmmoDamageConfig](../../AmmoDamageConfig.md)

**Signature**

```gdscript
func get_vehicle_damage_for(ammo_type: String) -> float
```

## Description

Returns vehicle-specific damage for the provided ammo type.

## Source

```gdscript
func get_vehicle_damage_for(ammo_type: String) -> float:
	return float(get_profile(ammo_type).get("vehicle_damage", 0.0))
```
