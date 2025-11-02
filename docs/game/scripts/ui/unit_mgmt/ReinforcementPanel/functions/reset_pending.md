# ReinforcementPanel::reset_pending Function Reference

*Defined at:* `scripts/ui/unit_mgmt/ReinforcementPanel.gd` (lines 92–101)</br>
*Belongs to:* [ReinforcementPanel](../../ReinforcementPanel.md)

**Signature**

```gdscript
func reset_pending() -> void
```

## Description

Clear the pending plan back to zero for all units.

## Source

```gdscript
func reset_pending() -> void:
	_pending.clear()
	_pool_remaining = _pool_total
	for uid: String in _rows.keys():
		_emit_preview(uid, 0)
	_update_all_rows_state()
	_update_pool_labels()
	_update_commit_enabled()
```
