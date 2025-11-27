# SimWorld::_mission_complete_check Function Reference

*Defined at:* `scripts/sim/SimWorld.gd` (lines 418–444)</br>
*Belongs to:* [SimWorld](../../SimWorld.md)

**Signature**

```gdscript
func _mission_complete_check(dt: float) -> void
```

- **dt**: Time since last tick.

## Description

Check if mission is complete.

## Source

```gdscript
func _mission_complete_check(dt: float) -> void:
	if _state != State.RUNNING:
		return
	var d := Game.resolution.to_summary_payload()
	var prim: Array = d.get("primary_objectives", [])
	var objs: Dictionary = d.get("objectives", {})
	if prim.is_empty():
		return

	var all_success := true
	var all_failed := true
	for id in prim:
		var st := int(objs.get(id, MissionResolution.ObjectiveState.PENDING))
		if st != MissionResolution.ObjectiveState.SUCCESS:
			all_success = false
		if st != MissionResolution.ObjectiveState.FAILED:
			all_failed = false

	var should_end := all_success or all_failed
	if should_end:
		_mission_complete_accum += dt
		if _mission_complete_accum >= auto_end_grace_s:
			complete(all_failed)
	else:
		_mission_complete_accum = 0.0
```
