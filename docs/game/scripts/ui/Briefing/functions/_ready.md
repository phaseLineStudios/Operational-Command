# Briefing::_ready Function Reference

*Defined at:* `scripts/ui/Briefing.gd` (lines 28–35)</br>
*Belongs to:* [Briefing](../Briefing.md)

**Signature**

```gdscript
func _ready() -> void
```

## Description

Init: load data, build board, wire UI.

## Source

```gdscript
func _ready() -> void:
	_btn_back.pressed.connect(func(): Game.goto_scene(SCENE_MISSION_SELECT))
	_btn_next.pressed.connect(func(): Game.goto_scene(SCENE_UNIT_SELECT))

	_load_brief()
	_build_board()
```
