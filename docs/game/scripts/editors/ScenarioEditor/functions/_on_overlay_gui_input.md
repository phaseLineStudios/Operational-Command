# ScenarioEditor::_on_overlay_gui_input Function Reference

*Defined at:* `scripts/editors/ScenarioEditor.gd` (lines 315–377)</br>
*Belongs to:* [ScenarioEditor](../../ScenarioEditor.md)

**Signature**

```gdscript
func _on_overlay_gui_input(event: InputEvent) -> void
```

## Description

Handle overlay input: hover, drag, link, select, and tool input

## Source

```gdscript
func _on_overlay_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if ctx.data and ctx.data.terrain:
			var mp = terrain_render.map_to_terrain(event.position)
			var grid := terrain_render.pos_to_grid(mp)
			mouse_position_label.text = "(%d, %d | %s)" % [mp.x, mp.y, grid]
			terrain_overlay.on_mouse_move(event.position)
		if draglink.linking:
			draglink.update_link(ctx, event.position)
		elif draglink.dragging:
			draglink.update_drag(ctx, event.position)

	if ctx.current_tool and ctx.current_tool.handle_input(event):
		return

	if event is InputEventMouseButton:
		if not event.pressed:
			if event.button_index == MOUSE_BUTTON_LEFT:
				if draglink.linking:
					var dst := terrain_overlay.get_pick_at(event.position)
					ScenarioTriggersService.new().try_sync_link(ctx, draglink.link_src_pick, dst)
					draglink.end_link(ctx)
					return
				if draglink.dragging:
					draglink.end_drag(ctx, true)
					return
			return

		if event.button_index == MOUSE_BUTTON_RIGHT:
			if draglink.dragging:
				draglink.end_drag(ctx, false)
				return
			if draglink.linking:
				draglink.end_link(ctx)
				return
			terrain_overlay.on_ctx_open(event)
			return

		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.ctrl_pressed:
				var src := terrain_overlay.get_pick_at(event.position)
				if (
					not src.is_empty()
					and StringName(src.get("type", "")) in [&"unit", &"task", &"trigger"]
				):
					LogService.trace(
						"BeginDrag: \n%s" % JSON.stringify(src), "ScenarioEditor.gd:416"
					)
					draglink.begin_link(ctx, src, event.position)
					return
			if event.double_click:
				terrain_overlay.on_dbl_click(event)
				return
			var pick := terrain_overlay.get_pick_at(event.position)
			if pick.is_empty():
				selection.clear_selection(ctx)
			else:
				selection.set_selection(ctx, pick)
				LogService.trace("BeginDrag: \n%s" % JSON.stringify(pick), "ScenarioEditor.gd:427")
				draglink.begin_drag(ctx, pick, event.position)
			return
```
