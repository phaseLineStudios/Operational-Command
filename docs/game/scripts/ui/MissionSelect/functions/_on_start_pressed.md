# MissionSelect::_on_start_pressed Function Reference

*Defined at:* `scripts/ui/MissionSelect.gd` (lines 272–287)</br>
*Belongs to:* [MissionSelect](../../MissionSelect.md)

**Signature**

```gdscript
func _on_start_pressed() -> void
```

## Description

Start current mission.

## Source

```gdscript
func _on_start_pressed() -> void:
	if not _selected_mission:
		return

	if _mission_locked.get(_selected_mission.id, false):
		push_warning("Cannot start locked mission: %s" % _selected_mission.id)
		return

	Game.select_scenario(_selected_mission)

	if _selected_mission.video:
		Game.goto_scene(SCENE_VIDEO)
	else:
		Game.goto_scene(SCENE_BRIEFING)
```
