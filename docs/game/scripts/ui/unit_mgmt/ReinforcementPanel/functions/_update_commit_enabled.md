# ReinforcementPanel::_update_commit_enabled Function Reference

*Defined at:* `scripts/ui/unit_mgmt/ReinforcementPanel.gd` (lines 237–241)</br>
*Belongs to:* [ReinforcementPanel](../../ReinforcementPanel.md)

**Signature**

```gdscript
func _update_commit_enabled() -> void
```

## Description

Enable Commit button only when there is any planned change.

## Source

```gdscript
func _update_commit_enabled() -> void:
	if _btn_commit:
		_btn_commit.disabled = (_pending_sum() <= 0)
```
