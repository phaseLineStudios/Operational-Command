# ReinforcementPanel::_pending_sum Function Reference

*Defined at:* `scripts/ui/unit_mgmt/ReinforcementPanel.gd` (lines 289–295)</br>
*Belongs to:* [ReinforcementPanel](../../ReinforcementPanel.md)

**Signature**

```gdscript
func _pending_sum() -> int
```

## Description

Sum of all pending allocations.

## Source

```gdscript
func _pending_sum() -> int:
	var t: int = 0
	for v in _pending.values():
		t += int(v)
	return t
```
