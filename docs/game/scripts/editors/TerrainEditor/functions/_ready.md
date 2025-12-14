# TerrainEditor::_ready Function Reference

*Defined at:* `scripts/editors/TerrainEditor.gd` (lines 62–85)</br>
*Belongs to:* [TerrainEditor](../../TerrainEditor.md)

**Signature**

```gdscript
func _ready()
```

## Source

```gdscript
func _ready():
	AudioManager.stop_music(0.5)

	file_menu.get_popup().connect("id_pressed", _on_filemenu_pressed)
	edit_menu.get_popup().connect("id_pressed", _on_editmenu_pressed)
	terrain_settings_dialog.connect("request_create", _new_terrain)
	terrain_settings_dialog.connect("request_edit", _edit_terrain)
	terrain_settings_dialog.editor = self
	brush_overlay.mouse_entered.connect(_on_brush_overlay_mouse_enter)
	brush_overlay.mouse_exited.connect(_on_brush_overlay_mouse_exit)
	brush_overlay.gui_input.connect(_on_brush_overlay_gui_input)
	terrain_render.data = data
	_build_tool_buttons()

	history.history_changed.connect(_on_history_changed)
	_on_history_changed([], [])

	get_tree().set_auto_accept_quit(false)
	_build_exit_dialog()

	tab_container_2.set_tab_title(0, "Tool Options")
	tab_container_3.set_tab_title(0, "Tool Info")
```
