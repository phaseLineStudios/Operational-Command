# ReinforcementPanel::refresh_from_units Function Reference

*Defined at:* `scripts/ui/unit_mgmt/ReinforcementPanel.gd` (lines 295–298)</br>
*Belongs to:* [ReinforcementPanel](../../ReinforcementPanel.md)

**Signature**

```gdscript
func refresh_from_units() -> void
```

## Description

Public: re-read UnitData and refresh all UI from the current state.

## Source

```gdscript
func refresh_from_units() -> void:
	_update_all_rows_state()
	_update_pool_labels()
	_update_commit_enabled()
```
