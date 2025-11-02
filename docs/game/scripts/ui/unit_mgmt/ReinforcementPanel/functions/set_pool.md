# ReinforcementPanel::set_pool Function Reference

*Defined at:* `scripts/ui/unit_mgmt/ReinforcementPanel.gd` (lines 81–90)</br>
*Belongs to:* [ReinforcementPanel](../../ReinforcementPanel.md)

**Signature**

```gdscript
func set_pool(amount: int) -> void
```

## Description

Set available replacements in the pool and refresh UI.

## Source

```gdscript
func set_pool(amount: int) -> void:
	_pool_total = max(0, amount)
	_pool_remaining = _pool_total - _pending_sum()
	_update_pool_labels()
	if not is_node_ready():
		call_deferred("_update_pool_labels")
	_update_all_rows_state()
	_update_commit_enabled()
```
