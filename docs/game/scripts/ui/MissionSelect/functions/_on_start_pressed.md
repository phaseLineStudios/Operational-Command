# MissionSelect::_on_start_pressed Function Reference

*Defined at:* `scripts/ui/MissionSelect.gd` (lines 241–245)</br>
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
	Game.select_scenario(_selected_mission)
	Game.goto_scene(SCENE_BRIEFING)
```
