# MissionSelect::_on_back_pressed Function Reference

*Defined at:* `scripts/ui/MissionSelect.gd` (lines 239–242)</br>
*Belongs to:* [MissionSelect](../MissionSelect.md)

**Signature**

```gdscript
func _on_back_pressed() -> void
```

## Description

Return to campaign select.

## Source

```gdscript
func _on_back_pressed() -> void:
	Game.goto_scene(SCENE_CAMPAIGN_SELECT)
```
