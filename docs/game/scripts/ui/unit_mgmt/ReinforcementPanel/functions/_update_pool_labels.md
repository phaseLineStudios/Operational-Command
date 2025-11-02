# ReinforcementPanel::_update_pool_labels Function Reference

*Defined at:* `scripts/ui/unit_mgmt/ReinforcementPanel.gd` (lines 230–235)</br>
*Belongs to:* [ReinforcementPanel](../../ReinforcementPanel.md)

**Signature**

```gdscript
func _update_pool_labels() -> void
```

## Description

Update the pool label.

## Source

```gdscript
func _update_pool_labels() -> void:
	var t := "Pool: %d / %d" % [_pool_remaining, _pool_total]
	if _lbl_pool:
		_lbl_pool.text = t
```
