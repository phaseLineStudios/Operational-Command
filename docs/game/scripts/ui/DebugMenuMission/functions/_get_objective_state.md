# DebugMenuMission::_get_objective_state Function Reference

*Defined at:* `scripts/ui/DebugMenuMission.gd` (lines 148–159)</br>
*Belongs to:* [DebugMenuMission](../../DebugMenuMission.md)

**Signature**

```gdscript
func _get_objective_state(obj_id: String) -> int
```

## Description

Get current objective state from Game.resolution

## Source

```gdscript
func _get_objective_state(obj_id: String) -> int:
	if not Game.resolution:
		return 0  # PENDING

	# Access the private _objective_states dict through reflection
	var obj_states: Dictionary = Game.resolution.get("_objective_states")
	if obj_states:
		return int(obj_states.get(obj_id, 0))

	return 0  # PENDING
```
