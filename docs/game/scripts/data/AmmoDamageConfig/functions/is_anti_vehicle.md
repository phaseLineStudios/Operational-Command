# AmmoDamageConfig::is_anti_vehicle Function Reference

*Defined at:* `scripts/data/AmmoDamageConfig.gd` (lines 30–33)</br>
*Belongs to:* [AmmoDamageConfig](../../AmmoDamageConfig.md)

**Signature**

```gdscript
func is_anti_vehicle(ammo_type: String) -> bool
```

## Description

Returns true if the ammo type is considered anti-vehicle capable.

## Source

```gdscript
func is_anti_vehicle(ammo_type: String) -> bool:
	return bool(get_profile(ammo_type).get("anti_vehicle", false))
```
