# ReinforcementPanel::set_units Function Reference

*Defined at:* `scripts/ui/unit_mgmt/ReinforcementPanel.gd` (lines 74–90)</br>
*Belongs to:* [ReinforcementPanel](../../ReinforcementPanel.md)

**Signature**

```gdscript
func set_units(units: Array[UnitData], unit_strengths: Dictionary = {}) -> void
```

- **units**: Array of UnitData templates.
- **unit_strengths**: Optional dictionary mapping unit_id -> current_strength (for campaign).

## Description

Provide the list of units to display. Rebuild rows and clear any plan.

## Source

```gdscript
func set_units(units: Array[UnitData], unit_strengths: Dictionary = {}) -> void:
	_units = []
	_rows.clear()
	_pending.clear()
	_unit_strength.clear()
	_clear_children(_rows_box)
	for u: UnitData in units:
		if u != null:
			_units.append(u)
			# Initialize strength (from campaign state or default to full strength)
			var uid := u.id
			_unit_strength[uid] = float(unit_strengths.get(uid, float(u.strength)))
	_build_rows()
	_update_pool_labels()
	_update_commit_enabled()
```
