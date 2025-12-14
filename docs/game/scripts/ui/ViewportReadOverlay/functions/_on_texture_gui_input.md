# ViewportReadOverlay::_on_texture_gui_input Function Reference

*Defined at:* `scripts/ui/ViewportReadOverlay.gd` (lines 61–101)</br>
*Belongs to:* [ViewportReadOverlay](../../ViewportReadOverlay.md)

**Signature**

```gdscript
func _on_texture_gui_input(event: InputEvent) -> void
```

## Source

```gdscript
func _on_texture_gui_input(event: InputEvent) -> void:
	if (
		event is InputEventMouseButton
		and event.pressed
		and event.button_index == MOUSE_BUTTON_RIGHT
	):
		get_viewport().set_input_as_handled()
		close()

	if not forward_input_to_viewport or _viewport == null:
		return

	if event is InputEventMouseButton:
		var mb := event as InputEventMouseButton
		var vp_pos: Vector2 = _map_global_to_viewport_pos(mb.global_position)
		if not vp_pos.is_finite():
			return
		var forward := InputEventMouseButton.new()
		forward.button_index = mb.button_index
		forward.pressed = mb.pressed
		forward.double_click = mb.double_click
		forward.position = vp_pos
		forward.global_position = vp_pos
		_viewport.push_input(forward)
		get_viewport().set_input_as_handled()
		return

	if event is InputEventMouseMotion:
		var mm := event as InputEventMouseMotion
		var vp_pos_motion: Vector2 = _map_global_to_viewport_pos(mm.global_position)
		if not vp_pos_motion.is_finite():
			return
		var fmm := InputEventMouseMotion.new()
		fmm.position = vp_pos_motion
		fmm.global_position = vp_pos_motion
		fmm.relative = mm.relative
		fmm.velocity = mm.velocity
		_viewport.push_input(fmm)
		get_viewport().set_input_as_handled()
```
