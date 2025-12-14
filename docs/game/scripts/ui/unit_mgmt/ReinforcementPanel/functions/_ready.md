# ReinforcementPanel::_ready Function Reference

*Defined at:* `scripts/ui/unit_mgmt/ReinforcementPanel.gd` (lines 62–70)</br>
*Belongs to:* [ReinforcementPanel](../../ReinforcementPanel.md)

**Signature**

```gdscript
func _ready() -> void
```

## Source

```gdscript
func _ready() -> void:
	if _btn_commit:
		_btn_commit.pressed.connect(commit)
	if _btn_reset:
		_btn_reset.pressed.connect(reset_pending)
	_update_pool_labels()
	_update_commit_enabled()
```
