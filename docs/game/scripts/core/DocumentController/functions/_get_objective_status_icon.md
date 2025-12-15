# DocumentController::_get_objective_status_icon Function Reference

*Defined at:* `scripts/core/DocumentController.gd` (lines 811–824)</br>
*Belongs to:* [DocumentController](../../DocumentController.md)

**Signature**

```gdscript
func _get_objective_status_icon(obj_id: String) -> String
```

## Description

Get status icon for an objective based on MissionResolution state

## Source

```gdscript
func _get_objective_status_icon(obj_id: String) -> String:
	if not _resolution:
		return "[   ]"

	var state = _resolution._objective_states.get(obj_id, MissionResolution.ObjectiveState.PENDING)
	match state:
		MissionResolution.ObjectiveState.SUCCESS:
			return "[✓]"
		MissionResolution.ObjectiveState.FAILED:
			return "[✗]"
		_:
			return "[   ]"
```
