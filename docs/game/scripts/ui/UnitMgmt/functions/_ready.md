# UnitMgmt::_ready Function Reference

*Defined at:* `scripts/ui/UnitMgmt.gd` (lines 21–27)</br>
*Belongs to:* [UnitMgmt](../../UnitMgmt.md)

**Signature**

```gdscript
func _ready() -> void
```

## Description

Scene is ready: wire signals and populate UI from Game.

## Source

```gdscript
func _ready() -> void:
	_btn_refresh.pressed.connect(_refresh_from_game)
	_panel.reinforcement_preview_changed.connect(_on_preview_changed)
	_panel.reinforcement_committed.connect(_on_committed)
	_refresh_from_game()
```
