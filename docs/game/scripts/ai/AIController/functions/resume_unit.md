# AIController::resume_unit Function Reference

*Defined at:* `scripts/ai/AIController.gd` (lines 112–116)</br>
*Belongs to:* [AIController](../../AIController.md)

**Signature**

```gdscript
func resume_unit(unit_id: int) -> void
```

## Description

Resume a paused unit's task processing.

## Source

```gdscript
func resume_unit(unit_id: int) -> void:
	if _runners.has(unit_id):
		_runners[unit_id].resume()
```
