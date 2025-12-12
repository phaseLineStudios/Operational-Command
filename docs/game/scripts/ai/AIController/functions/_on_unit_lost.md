# AIController::_on_unit_lost Function Reference

*Defined at:* `scripts/ai/AIController.gd` (lines 536–541)</br>
*Belongs to:* [AIController](../../AIController.md)

**Signature**

```gdscript
func _on_unit_lost(_unit_id: String) -> void
```

## Description

Handle unit lost event (placeholder).

## Source

```gdscript
func _on_unit_lost(_unit_id: String) -> void:
	var idx := _uid_to_index(_unit_id)
	if idx >= 0:
		pause_unit(idx)
```
