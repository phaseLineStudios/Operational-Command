# DebugMenuMission::_set_objective_state Function Reference

*Defined at:* `scripts/ui/DebugMenuMission.gd` (lines 161–179)</br>
*Belongs to:* [DebugMenuMission](../../DebugMenuMission.md)

**Signature**

```gdscript
func _set_objective_state(obj_id: String, state_int: int) -> void
```

## Description

Set objective state through Game

## Source

```gdscript
func _set_objective_state(obj_id: String, state_int: int) -> void:
	if not Game.resolution:
		LogService.warn("Cannot set objective state: no resolution instance", "DebugMenuMission")
		return

	var state_name := ""
	match state_int:
		0:
			state_name = "PENDING"
		1:
			state_name = "SUCCESS"
		2:
			state_name = "FAILED"
		_:
			LogService.error("Invalid objective state: %d" % state_int, "DebugMenuMission")
			return

	Game.set_objective_state(obj_id, state_int)
	LogService.info("DEBUG: Set objective '%s' to %s" % [obj_id, state_name], "DebugMenuMission")
```
