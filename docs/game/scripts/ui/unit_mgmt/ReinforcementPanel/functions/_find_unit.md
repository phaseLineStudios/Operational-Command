# ReinforcementPanel::_find_unit Function Reference

*Defined at:* `scripts/ui/unit_mgmt/ReinforcementPanel.gd` (lines 281–287)</br>
*Belongs to:* [ReinforcementPanel](../../ReinforcementPanel.md)

**Signature**

```gdscript
func _find_unit(uid: String) -> UnitData
```

## Description

Find a UnitData by id.

## Source

```gdscript
func _find_unit(uid: String) -> UnitData:
	for u: UnitData in _units:
		if u != null and u.id == uid:
			return u
	return null
```
