# UnitData::_ammo_key_to_index Function Reference

*Defined at:* `scripts/data/UnitData.gd` (lines 519–529)</br>
*Belongs to:* [UnitData](../../UnitData.md)

**Signature**

```gdscript
func _ammo_key_to_index(ammo_key: String) -> int
```

## Description

Convert ammo key name to enum index.

## Source

```gdscript
static func _ammo_key_to_index(ammo_key: String) -> int:
	if ammo_key == "":
		return -1
	var key_upper := ammo_key.to_upper()
	var keys := AmmoTypes.keys()
	for i in range(keys.size()):
		if String(keys[i]).to_upper() == key_upper:
			return i
	return -1
```
