# AIController::is_unit_idle Function Reference

*Defined at:* `scripts/ai/AIController.gd` (lines 99–104)</br>
*Belongs to:* [AIController](../../AIController.md)

**Signature**

```gdscript
func is_unit_idle(unit_id: int) -> bool
```

## Description

True if a unit has no active or queued tasks in its runner.

## Source

```gdscript
func is_unit_idle(unit_id: int) -> bool:
	if not _runners.has(unit_id):
		return true
	return _runners[unit_id].is_idle()
```
