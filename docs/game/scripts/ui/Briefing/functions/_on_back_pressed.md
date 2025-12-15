# Briefing::_on_back_pressed Function Reference

*Defined at:* `scripts/ui/Briefing.gd` (lines 59–64)</br>
*Belongs to:* [Briefing](../../Briefing.md)

**Signature**

```gdscript
func _on_back_pressed() -> void
```

## Description

Handle back button press

## Source

```gdscript
func _on_back_pressed() -> void:
	if Game.play_mode == Game.PlayMode.SOLO_PLAY_TEST:
		Game.end_playtest()
	else:
		Game.goto_scene(SCENE_MISSION_SELECT)
```
