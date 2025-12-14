# AIController::_on_unit_unbogged Function Reference

*Defined at:* `scripts/ai/AIController.gd` (lines 558–563)</br>
*Belongs to:* [AIController](../../AIController.md)

**Signature**

```gdscript
func _on_unit_unbogged(_unit_id: String) -> void
```

## Description

Handle unit unbogged event (placeholder).

## Source

```gdscript
func _on_unit_unbogged(_unit_id: String) -> void:
	var idx := _uid_to_index(_unit_id)
	if idx >= 0:
		resume_unit(idx)
```
