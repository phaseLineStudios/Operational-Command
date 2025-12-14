# AIController::_on_unit_bogged Function Reference

*Defined at:* `scripts/ai/AIController.gd` (lines 550–556)</br>
*Belongs to:* [AIController](../../AIController.md)

**Signature**

```gdscript
func _on_unit_bogged(_unit_id: String) -> void
```

## Description

Handle unit bogged event (placeholder).

## Source

```gdscript
func _on_unit_bogged(_unit_id: String) -> void:
	var idx := _uid_to_index(_unit_id)
	if idx >= 0:
		pause_unit(idx)
		_request_engineer_if_available(idx)
```
