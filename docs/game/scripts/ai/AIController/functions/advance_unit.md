# AIController::advance_unit Function Reference

*Defined at:* `scripts/ai/AIController.gd` (lines 124–128)</br>
*Belongs to:* [AIController](../../AIController.md)

**Signature**

```gdscript
func advance_unit(unit_id: int) -> void
```

## Description

Force-advance to the next task in the queue.

## Source

```gdscript
func advance_unit(unit_id: int) -> void:
	if _runners.has(unit_id):
		_runners[unit_id].advance()
```
