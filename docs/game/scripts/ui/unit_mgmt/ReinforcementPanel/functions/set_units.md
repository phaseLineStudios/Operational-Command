# ReinforcementPanel::set_units Function Reference

*Defined at:* `scripts/ui/unit_mgmt/ReinforcementPanel.gd` (lines 67–79)</br>
*Belongs to:* [ReinforcementPanel](../../ReinforcementPanel.md)

**Signature**

```gdscript
func set_units(units: Array[UnitData]) -> void
```

## Description

Provide the list of units to display. Rebuild rows and clear any plan.

## Source

```gdscript
func set_units(units: Array[UnitData]) -> void:
	_units = []
	_rows.clear()
	_pending.clear()
	_clear_children(_rows_box)
	for u: UnitData in units:
		if u != null:
			_units.append(u)
	_build_rows()
	_update_pool_labels()
	_update_commit_enabled()
```
