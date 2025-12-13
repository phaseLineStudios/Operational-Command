# DocumentController::_on_objective_updated Function Reference

*Defined at:* `scripts/core/DocumentController.gd` (lines 780–783)</br>
*Belongs to:* [DocumentController](../../DocumentController.md)

**Signature**

```gdscript
func _on_objective_updated(_obj_id: String, _state: int) -> void
```

## Description

Handle objective state changes and refresh briefing

## Source

```gdscript
func _on_objective_updated(_obj_id: String, _state: int) -> void:
	_refresh_briefing_objectives()
```
