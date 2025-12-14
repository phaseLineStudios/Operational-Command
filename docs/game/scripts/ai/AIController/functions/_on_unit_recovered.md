# AIController::_on_unit_recovered Function Reference

*Defined at:* `scripts/ai/AIController.gd` (lines 543–548)</br>
*Belongs to:* [AIController](../../AIController.md)

**Signature**

```gdscript
func _on_unit_recovered(_unit_id: String) -> void
```

## Description

Handle unit recovered event (placeholder).

## Source

```gdscript
func _on_unit_recovered(_unit_id: String) -> void:
	var idx := _uid_to_index(_unit_id)
	if idx >= 0:
		resume_unit(idx)
```
