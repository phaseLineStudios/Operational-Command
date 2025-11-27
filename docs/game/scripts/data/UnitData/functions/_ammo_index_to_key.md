# UnitData::_ammo_index_to_key Function Reference

*Defined at:* `scripts/data/UnitData.gd` (lines 548–556)</br>
*Belongs to:* [UnitData](../../UnitData.md)

**Signature**

```gdscript
func _ammo_index_to_key(idx: int) -> String
```

## Description

Convert ammo enum index -> string key ("SMALL_ARMS").

## Source

```gdscript
static func _ammo_index_to_key(idx: int) -> String:
	if idx < 0:
		return ""
	var keys := AmmoTypes.keys()
	if idx >= 0 and idx < keys.size():
		return String(keys[idx])
	return ""
```
