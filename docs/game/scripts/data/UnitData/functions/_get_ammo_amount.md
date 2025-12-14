# UnitData::_get_ammo_amount Function Reference

*Defined at:* `scripts/data/UnitData.gd` (lines 531–541)</br>
*Belongs to:* [UnitData](../../UnitData.md)

**Signature**

```gdscript
func _get_ammo_amount(source: Dictionary, ammo_key: String) -> float
```

## Description

Safely fetch an ammo value from a dictionary that might use string or numeric keys.

## Source

```gdscript
static func _get_ammo_amount(source: Dictionary, ammo_key: String) -> float:
	if typeof(source) != TYPE_DICTIONARY or ammo_key == "":
		return 0.0
	if source.has(ammo_key):
		return float(source[ammo_key])
	var idx := _ammo_key_to_index(ammo_key)
	if idx >= 0 and source.has(idx):
		return float(source[idx])
	return 0.0
```
