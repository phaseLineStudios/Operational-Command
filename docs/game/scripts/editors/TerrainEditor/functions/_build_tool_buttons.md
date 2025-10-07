# TerrainEditor::_build_tool_buttons Function Reference

*Defined at:* `scripts/editors/TerrainEditor.gd` (lines 174–231)</br>
*Belongs to:* [TerrainEditor](../../TerrainEditor.md)

**Signature**

```gdscript
func _build_tool_buttons()
```

## Description

Build the tool panel

## Source

```gdscript
func _build_tool_buttons():
	for tool_script in TOOL_ORDER:
		var s := load(tool_script) as Script
		var tool: TerrainToolBase = TerrainToolBase.new()
		tool.set_script(s)
		tool.editor = self
		tool.render = terrain_render
		tool.viewport_container = terrainview_container
		tool.viewport = terrainview
		tool.data = data
		tool.brushes = brushes
		tool.features = features
		tool.on_options_changed.connect(_rebuild_options_panel)
		tool.on_hints_changed.connect(_rebuild_tool_hint)
		tool.on_need_info.connect(_rebuild_info_panel)

		var btn := TextureButton.new()
		btn.ignore_texture_size = true
		btn.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
		btn.custom_minimum_size = tool_icon_size
		btn.toggle_mode = true
		tool_map[btn] = tool
		btn.tooltip_text = tool.tool_hint
		btn.texture_normal = tool.tool_icon
		btn.self_modulate = Color(1, 1, 1, 0.4)
		btn.set_meta("hovered", false)
		tools_grid.add_child(btn)

		btn.mouse_entered.connect(
			func():
				btn.set_meta("hovered", true)
				_update_tool_button_tint(btn)
		)
		btn.mouse_exited.connect(
			func():
				btn.set_meta("hovered", false)
				_update_tool_button_tint(btn)
		)
		btn.focus_entered.connect(
			func():
				btn.set_meta("hovered", true)
				_update_tool_button_tint(btn)
		)
		btn.focus_exited.connect(
			func():
				btn.set_meta("hovered", false)
				_update_tool_button_tint(btn)
		)
		btn.toggled.connect(
			func(pressed: bool):
				_update_tool_button_tint(btn)
				if pressed:
					_select_tool(btn)
				else:
					_deselect_tool(btn)
		)
```
