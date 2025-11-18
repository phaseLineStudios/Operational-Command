# AmmoDamageConfig::get_damage_for Function Reference

*Defined at:* `scripts/data/AmmoDamageConfig.gd` (lines 15–18)</br>
*Belongs to:* [AmmoDamageConfig](../../AmmoDamageConfig.md)

**Signature**

```gdscript
func get_damage_for(ammo_type: String) -> float
```

## Description

Returns the configured damage value for the provided ammo type.

## Source

```gdscript
func get_damage_for(ammo_type: String) -> float:
	return float(get_profile(ammo_type).get("damage", 0.0))
```
