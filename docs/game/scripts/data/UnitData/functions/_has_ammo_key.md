# UnitData::_has_ammo_key Function Reference

*Defined at:* `scripts/data/UnitData.gd` (lines 582–590)</br>
*Belongs to:* [UnitData](../../UnitData.md)

**Signature**

```gdscript
func _has_ammo_key(source: Dictionary, ammo_key: String) -> bool
```

## Description

Returns true if the dictionary contains the ammo key as string or enum index.

## Source

```gdscript
static func _has_ammo_key(source: Dictionary, ammo_key: String) -> bool:
	if typeof(source) != TYPE_DICTIONARY or ammo_key == "":
		return false
	if source.has(ammo_key):
		return true
	var idx := _ammo_key_to_index(ammo_key)
	return idx >= 0 and source.has(idx)
```
