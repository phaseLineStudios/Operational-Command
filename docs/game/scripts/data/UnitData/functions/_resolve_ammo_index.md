# UnitData::_resolve_ammo_index Function Reference

*Defined at:* `scripts/data/UnitData.gd` (lines 597–604)</br>
*Belongs to:* [UnitData](../../UnitData.md)

**Signature**

```gdscript
func _resolve_ammo_index(value: Variant) -> int
```

## Description

Normalize mixed ammo representations (string/int) to an enum index.

## Source

```gdscript
static func _resolve_ammo_index(value: Variant) -> int:
	match typeof(value):
		TYPE_STRING:
			return _ammo_key_to_index(String(value))
		TYPE_INT, TYPE_FLOAT:
			return int(value)
		_:
			return -1
```
