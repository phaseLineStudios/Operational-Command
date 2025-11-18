# AmmoDamageConfig::get_profile Function Reference

*Defined at:* `scripts/data/AmmoDamageConfig.gd` (lines 20–23)</br>
*Belongs to:* [AmmoDamageConfig](../../AmmoDamageConfig.md)

**Signature**

```gdscript
func get_profile(ammo_type: String) -> Dictionary
```

## Description

Returns the metadata profile for an ammo type (damage, tags, etc.).

## Source

```gdscript
func get_profile(ammo_type: String) -> Dictionary:
	return _resolve_profile(ammo_type, []).duplicate(true)
```
