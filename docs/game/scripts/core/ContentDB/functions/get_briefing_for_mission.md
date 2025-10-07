# ContentDB::get_briefing_for_mission Function Reference

*Defined at:* `scripts/core/ContentDB.gd` (lines 277–280)</br>
*Belongs to:* [ContentDB](../../ContentDB.md)

**Signature**

```gdscript
func get_briefing_for_mission(mission_id: String) -> BriefData
```

## Description

Convenience explicit mission briefing resolver.

## Source

```gdscript
func get_briefing_for_mission(mission_id: String) -> BriefData:
	return get_briefing(mission_id)
```
