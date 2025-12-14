# MissionSelect::is_mission_available Function Reference

*Defined at:* `scripts/ui/MissionSelect.gd` (lines 343–346)</br>
*Belongs to:* [MissionSelect](../../MissionSelect.md)

**Signature**

```gdscript
func is_mission_available(mission: ScenarioData) -> bool
```

## Description

Check if a mission is available to play.

## Source

```gdscript
func is_mission_available(mission: ScenarioData) -> bool:
	return not _mission_locked.get(mission.id, true)
```
