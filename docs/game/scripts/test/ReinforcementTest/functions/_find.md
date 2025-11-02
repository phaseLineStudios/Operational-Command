# ReinforcementTest::_find Function Reference

*Defined at:* `scripts/test/ReinforcementTest.gd` (lines 303–307)</br>
*Belongs to:* [ReinforcementTest](../../ReinforcementTest.md)

**Signature**

```gdscript
func _find(uid: String) -> UnitData
```

## Description

Lookup by id

## Source

```gdscript
func _find(uid: String) -> UnitData:
	for u: UnitData in _units:
		if u.id == uid:
			return u
	return null
```
