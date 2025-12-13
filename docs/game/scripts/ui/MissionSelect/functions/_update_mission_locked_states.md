# MissionSelect::_update_mission_locked_states Function Reference

*Defined at:* `scripts/ui/MissionSelect.gd` (lines 323–341)</br>
*Belongs to:* [MissionSelect](../../MissionSelect.md)

**Signature**

```gdscript
func _update_mission_locked_states() -> void
```

## Description

Update which missions are locked based on campaign progression.
First mission is always unlocked; subsequent missions require previous mission completion.

## Source

```gdscript
func _update_mission_locked_states() -> void:
	_mission_locked.clear()

	if not Game.current_save:
		for i in range(_scenarios.size()):
			_mission_locked[_scenarios[i].id] = (i > 0)
		return

	for i in range(_scenarios.size()):
		var mission := _scenarios[i]

		if i == 0:
			_mission_locked[mission.id] = false
		else:
			var prev_mission := _scenarios[i - 1]
			var is_prev_completed := Game.current_save.is_mission_completed(prev_mission.id)
			_mission_locked[mission.id] = not is_prev_completed
```
