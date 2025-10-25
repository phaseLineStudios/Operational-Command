# TriggerEngine::_check_presence Function Reference

*Defined at:* `scripts/sim/scenario/TriggerEngine.gd` (lines 92–112)</br>
*Belongs to:* [TriggerEngine](../../TriggerEngine.md)

**Signature**

```gdscript
func _check_presence(t: ScenarioTrigger) -> bool
```

- **t**: Trigger to check unit presence on.
- **Return Value**: True if presence passes.

## Description

Check trigger unit presence.

## Source

```gdscript
func _check_presence(t: ScenarioTrigger) -> bool:
	if t.presence == ScenarioTrigger.PresenceMode.NONE:
		return true
	var inside := _counts_in_area(t.area_center_m, t.area_size_m, t.area_shape)
	match t.presence:
		ScenarioTrigger.PresenceMode.PLAYER_INSIDE:
			return inside.player > 0
		ScenarioTrigger.PresenceMode.FRIEND_INSIDE:
			return inside.friend > 0
		ScenarioTrigger.PresenceMode.ENEMY_INSIDE:
			return inside.enemy > 0
		ScenarioTrigger.PresenceMode.PLAYER_NOT_INSIDE:
			return inside.player == 0
		ScenarioTrigger.PresenceMode.FRIEND_NOT_INSIDE:
			return inside.friend == 0
		ScenarioTrigger.PresenceMode.ENEMY_NOT_INSIDE:
			return inside.enemy == 0
		_:
			return true
```
