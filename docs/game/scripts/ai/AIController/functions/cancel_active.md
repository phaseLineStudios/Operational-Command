# AIController::cancel_active Function Reference

*Defined at:* `scripts/ai/AIController.gd` (lines 119–123)</br>
*Belongs to:* [AIController](../../AIController.md)

**Signature**

```gdscript
func cancel_active(unit_id: int) -> void
```

## Description

Cancel the active task (runner will start the next queued task).

## Source

```gdscript
func cancel_active(unit_id: int) -> void:
	if _runners.has(unit_id):
		_runners[unit_id].cancel_active()
```
