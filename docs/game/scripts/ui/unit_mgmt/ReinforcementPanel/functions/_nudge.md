# ReinforcementPanel::_nudge Function Reference

*Defined at:* `scripts/ui/unit_mgmt/ReinforcementPanel.gd` (lines 251–255)</br>
*Belongs to:* [ReinforcementPanel](../../ReinforcementPanel.md)

**Signature**

```gdscript
func _nudge(uid: String, delta: int) -> void
```

## Description

Change planned amount by a delta.

## Source

```gdscript
func _nudge(uid: String, delta: int) -> void:
	var target: int = int(_pending.get(uid, 0)) + delta
	_set_amount(uid, target)
```
