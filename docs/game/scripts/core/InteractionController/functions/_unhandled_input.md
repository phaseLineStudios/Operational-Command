# InteractionController::_unhandled_input Function Reference

*Defined at:* `scripts/core/PlayerInteraction.gd` (lines 26–77)</br>
*Belongs to:* [InteractionController](../../InteractionController.md)

**Signature**

```gdscript
func _unhandled_input(event: InputEvent) -> void
```

## Source

```gdscript
func _unhandled_input(event: InputEvent) -> void:
	if _held != null and _held.is_inspecting():
		var handled := _held.handle_inspect_input(event)
		if handled:
			get_viewport().set_input_as_handled()
			if _held != null and not _held.is_inspecting():
				if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
					_resume_drag_after_inspect = true
				elif event is InputEventKey and event.keycode == KEY_ESCAPE:
					_resume_drag_after_inspect = false
					_drop_held()
				else:
					_resume_drag_after_inspect = false
		return

	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == MOUSE_BUTTON_LEFT and event.double_click:
			if _held != null and _held.inspect_enabled:
				_held.toggle_inspect(camera)
				get_viewport().set_input_as_handled()
				return
			else:
				_try_pickup(event.position)
				if _held and _held.inspect_enabled:
					_held.start_inspect(camera)
					get_viewport().set_input_as_handled()
					return

		if event.button_index == MOUSE_BUTTON_LEFT and _held == null:
			_try_pickup(event.position)
			if _held:
				get_viewport().set_input_as_handled()
				return
		if event.button_index == MOUSE_BUTTON_RIGHT and _held != null and _held.pick_toggle:
			_drop_held()
			get_viewport().set_input_as_handled()
			return

	if event is InputEventMouseButton and event.is_released():
		if event.button_index == MOUSE_BUTTON_LEFT and _held != null and not _held.pick_toggle:
			if _held.is_inspecting():
				get_viewport().set_input_as_handled()
				return
			if _resume_drag_after_inspect:
				_resume_drag_after_inspect = false
				get_viewport().set_input_as_handled()
				return
			_drop_held()
			get_viewport().set_input_as_handled()
			return
```
