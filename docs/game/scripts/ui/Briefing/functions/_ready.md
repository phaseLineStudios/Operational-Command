# Briefing::_ready Function Reference

*Defined at:* `scripts/ui/Briefing.gd` (lines 28–39)</br>
*Belongs to:* [Briefing](../../Briefing.md)

**Signature**

```gdscript
func _ready() -> void
```

## Description

Init: load data, build board, wire UI.

## Source

```gdscript
func _ready() -> void:
	_btn_back.pressed.connect(_on_back_pressed)
	_btn_next.pressed.connect(func(): Game.goto_scene(SCENE_UNIT_SELECT))

	# Update back button text based on play mode
	if Game.play_mode == Game.PlayMode.SOLO_PLAY_TEST:
		_btn_back.text = "Back to Editor"

	_load_brief()
	_build_board()
```
