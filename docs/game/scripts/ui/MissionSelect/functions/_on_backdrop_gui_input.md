# MissionSelect::_on_backdrop_gui_input Function Reference

*Defined at:* `scripts/ui/MissionSelect.gd` (lines 244–254)</br>
*Belongs to:* [MissionSelect](../MissionSelect.md)

**Signature**

```gdscript
func _on_backdrop_gui_input(event: InputEvent) -> void
```

## Description

Decide if an overlay click should close the card.

## Source

```gdscript
func _on_backdrop_gui_input(event: InputEvent) -> void:
	if not _card.visible:
		return
	var mb := event as InputEventMouseButton
	if mb and mb.pressed and mb.button_index == MOUSE_BUTTON_LEFT:
		var pt: Vector2 = mb.position
		if _card.get_global_rect().has_point(pt):
			return
		_close_card()
```
