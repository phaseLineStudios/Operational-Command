# UnitData::_default_ammo_damage Function Reference

*Defined at:* `scripts/data/UnitData.gd` (lines 592–595)</br>
*Belongs to:* [UnitData](../../UnitData.md)

**Signature**

```gdscript
func _default_ammo_damage(ammo_key: String) -> float
```

## Description

Fallback damage when no config entry is available.

## Source

```gdscript
static func _default_ammo_damage(ammo_key: String) -> float:
	return float(_DEFAULT_AMMO_DAMAGE.get(ammo_key, 1.0))
```
