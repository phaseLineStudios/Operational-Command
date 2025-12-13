# UnitMgmt::_find_unit Function Reference

*Defined at:* `scripts/ui/UnitMgmt.gd` (lines 145–151)</br>
*Belongs to:* [UnitMgmt](../../UnitMgmt.md)

**Signature**

```gdscript
func _find_unit(uid: String) -> UnitData
```

## Description

Find a unit by id in the cached list.

## Source

```gdscript
func _find_unit(uid: String) -> UnitData:
	for u in _units:
		if u and u.id == uid:
			return u
	return null
```
