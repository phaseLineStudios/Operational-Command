# MilSymbolTest::_input Function Reference

*Defined at:* `scripts/test/MilSymbolTest.gd` (lines 49–69)</br>
*Belongs to:* [MilSymbolTest](../../MilSymbolTest.md)

**Signature**

```gdscript
func _input(event: InputEvent) -> void
```

## Description

Handle Enter for designation and arrow-key selection for focused OptionButtons.

## Source

```gdscript
func _input(event: InputEvent) -> void:
	if not (event is InputEventKey and event.pressed and not event.echo):
		return

	if u_designation.has_focus() and event.keycode == KEY_ENTER:
		_generate_symbols()
		accept_event()
		return

	var focused := get_viewport().gui_get_focus_owner()
	if not (focused is OptionButton):
		return

	if event.is_action_pressed("ui_up") or event.is_action_pressed("ui_left"):
		_change_option_selection(focused, -1)
		accept_event()
	elif event.is_action_pressed("ui_down") or event.is_action_pressed("ui_right"):
		_change_option_selection(focused, +1)
		accept_event()
```
