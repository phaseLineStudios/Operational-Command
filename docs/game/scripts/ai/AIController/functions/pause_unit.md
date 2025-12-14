# AIController::pause_unit Function Reference

*Defined at:* `scripts/ai/AIController.gd` (lines 107–111)</br>
*Belongs to:* [AIController](../../AIController.md)

**Signature**

```gdscript
func pause_unit(unit_id: int) -> void
```

## Description

Pause the unit's task processing (current task remains active).

## Source

```gdscript
func pause_unit(unit_id: int) -> void:
	if _runners.has(unit_id):
		_runners[unit_id].pause()
```
