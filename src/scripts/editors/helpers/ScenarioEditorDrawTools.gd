class_name ScenarioEditorDrawTools
extends RefCounted
## Helper for managing drawing tools in the Scenario Editor.
##
## Handles freehand, stamp, and eraser tool activation, settings synchronization,
## stamp pool management, and drawing ID generation.

## Reference to parent ScenarioEditor
var editor: ScenarioEditor

## Cached drawing textures loaded from stamp pool
var draw_textures: Array[Texture2D] = []

## Paths to cached drawing textures
var draw_tex_paths: Array[String] = []

## Default settings for freehand tool
var freehand_defaults := {"color": Color(0.9, 0.9, 0.2, 1), "width_px": 3.0, "opacity": 1.0}

## Default settings for stamp tool
var stamp_defaults := {"scale": 1.0, "rotation_deg": 0.0, "opacity": 1.0, "label": ""}


## Initialize with parent editor reference.
## [param parent] Parent ScenarioEditor instance.
func init(parent: ScenarioEditor) -> void:
	editor = parent


## Populate stamp list from terrain brush textures.
func build_stamp_pool() -> void:
	draw_textures.clear()
	draw_tex_paths.clear()
	editor.st_list.clear()

	var dir := DirAccess.open("res://assets/textures/stamps")
	if dir:
		dir.list_dir_begin()
		while true:
			var f := dir.get_next()
			if f == "":
				break
			if dir.current_is_dir():
				continue
			if (
				f.to_lower().ends_with(".png")
				or f.to_lower().ends_with(".webp")
				or f.to_lower().ends_with(".jpg")
			):
				var p := "res://assets/textures/stamps/%s" % f
				var t: Texture2D = load(p)
				if t:
					var idx := editor.st_list.add_item(f.get_basename())
					var icon_img := t.get_image()
					icon_img.resize(32, 32, Image.INTERPOLATE_LANCZOS)
					editor.st_list.set_item_icon(idx, ImageTexture.create_from_image(icon_img))
					editor.st_list.set_item_metadata(idx, {"path": p})
					draw_textures.append(t)
					draw_tex_paths.append(p)
		dir.list_dir_end()


## Start freehand tool with current UI values.
func on_draw_click_freehand() -> void:
	# If button is being toggled off, clear the tool
	if not editor.draw_toolbar_freehand.button_pressed:
		editor._clear_tool()
		editor.fh_settings.visible = false
		return

	# Deactivate other tool buttons
	editor.draw_toolbar_stamp.set_pressed_no_signal(false)
	editor.draw_toolbar_eraser.set_pressed_no_signal(false)

	# Show freehand settings, hide others
	editor.fh_settings.visible = true
	editor.st_settings.visible = false
	editor.st_label.visible = false
	editor.st_seperator.visible = false
	editor.st_list.visible = false
	editor.st_load_btn.visible = false

	# Create and activate freehand tool
	var tool := DrawFreehandTool.new()
	tool.color = editor.fh_color.color
	tool.width_px = editor.fh_width.value
	tool.opacity = editor.fh_opacity.value
	editor._set_tool(tool)


## Start stamp tool with current UI + selected texture.
func on_draw_click_stamp() -> void:
	# If button is being toggled off, clear the tool
	if not editor.draw_toolbar_stamp.button_pressed:
		editor._clear_tool()
		editor.st_settings.visible = false
		editor.st_label.visible = false
		editor.st_seperator.visible = false
		editor.st_list.visible = false
		editor.st_load_btn.visible = false
		return

	# Deactivate other tool buttons
	editor.draw_toolbar_freehand.set_pressed_no_signal(false)
	editor.draw_toolbar_eraser.set_pressed_no_signal(false)

	# Show stamp settings, hide others
	editor.fh_settings.visible = false
	editor.st_settings.visible = true
	editor.st_seperator.visible = true
	editor.st_label.visible = true
	editor.st_load_btn.visible = true
	editor.st_list.visible = true

	# Try to activate tool if texture is selected, otherwise just show UI
	var sel := editor.st_list.get_selected_items()
	if not sel.is_empty():
		var idx := sel[0]
		var tool := DrawTextureTool.new()
		tool.texture_path = String(editor.st_list.get_item_metadata(idx).get("path", ""))
		tool.texture = load(tool.texture_path)
		tool.color = editor.st_color.color
		tool.scale = editor.st_scale.value
		tool.rotation_deg = editor.st_rotation.value
		tool.opacity = editor.st_opacity.value
		tool.label = editor.st_label_text.text
		editor._set_tool(tool)


## Start eraser tool.
func on_draw_click_eraser() -> void:
	# If button is being toggled off, clear the tool
	if not editor.draw_toolbar_eraser.button_pressed:
		editor._clear_tool()
		return

	# Deactivate other tool buttons
	editor.draw_toolbar_freehand.set_pressed_no_signal(false)
	editor.draw_toolbar_stamp.set_pressed_no_signal(false)

	# Hide all settings
	editor.fh_settings.visible = false
	editor.st_settings.visible = false
	editor.st_label.visible = false
	editor.st_seperator.visible = false
	editor.st_list.visible = false
	editor.st_load_btn.visible = false

	# Create and activate eraser tool
	var tool := DrawEraserTool.new()
	editor._set_tool(tool)


## Update active freehand tool when UI changes.
func sync_freehand_opts() -> void:
	freehand_defaults.color = editor.fh_color.color
	freehand_defaults.width_px = editor.fh_width.value
	freehand_defaults.opacity = editor.fh_opacity.value
	if editor.ctx.current_tool and editor.ctx.current_tool is DrawFreehandTool:
		editor.ctx.current_tool.color = editor.fh_color.color
		editor.ctx.current_tool.width_px = editor.fh_width.value
		editor.ctx.current_tool.opacity = editor.fh_opacity.value
		editor.ctx.request_overlay_redraw()


## Update active stamp tool when UI changes.
func sync_stamp_opts() -> void:
	stamp_defaults.color = editor.st_color.color
	stamp_defaults.scale = editor.st_scale.value
	stamp_defaults.rotation_deg = editor.st_rotation.value
	stamp_defaults.opacity = editor.st_opacity.value
	stamp_defaults.label = editor.st_label_text.text
	if editor.ctx.current_tool and editor.ctx.current_tool is DrawTextureTool:
		editor.ctx.current_tool.color = editor.st_color.color
		editor.ctx.current_tool.scale = editor.st_scale.value
		editor.ctx.current_tool.rotation_deg = editor.st_rotation.value
		editor.ctx.current_tool.opacity = editor.st_opacity.value
		editor.ctx.current_tool.label = editor.st_label_text.text
		editor.ctx.request_overlay_redraw()


## Handle stamp selection change.
## [param idx] Item index.
func on_stamp_selected(idx: int) -> void:
	# If tool is already active, just update the texture
	if editor.ctx.current_tool and editor.ctx.current_tool is DrawTextureTool:
		var p := String(editor.st_list.get_item_metadata(idx).get("path", ""))
		editor.ctx.current_tool.texture_path = p
		editor.ctx.current_tool.texture = load(p)
		editor.ctx.request_overlay_redraw()
	# If stamp button is pressed but tool not active, activate it now
	elif editor.draw_toolbar_stamp.button_pressed:
		var tool := DrawTextureTool.new()
		tool.texture_path = String(editor.st_list.get_item_metadata(idx).get("path", ""))
		tool.texture = load(tool.texture_path)
		tool.color = editor.st_color.color
		tool.scale = editor.st_scale.value
		tool.rotation_deg = editor.st_rotation.value
		tool.opacity = editor.st_opacity.value
		tool.label = editor.st_label_text.text
		editor._set_tool(tool)


## Load a texture from disk into pool.
func on_stamp_load_clicked() -> void:
	var fd := FileDialog.new()
	fd.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	fd.access = FileDialog.ACCESS_RESOURCES
	fd.filters = PackedStringArray(["*.png,*.webp,*.jpg ; Images"])
	fd.title = "Select Texture"
	editor.add_child(fd)
	fd.file_selected.connect(
		func(p: String):
			var t: Texture2D = load(p)
			if t:
				var idx := editor.st_list.add_item(p.get_file())
				var icon_img := t.get_image()
				icon_img.resize(32, 32, Image.INTERPOLATE_LANCZOS)
				editor.st_list.set_item_icon(idx, ImageTexture.create_from_image(icon_img))
				editor.st_list.set_item_metadata(idx, {"path": p})
			fd.queue_free()
	)
	fd.popup_centered_ratio(0.6)


## Generate unique drawing id.
## [param kind] "stroke" | "stamp".
## [return] Unique drawing ID string.
func next_drawing_id(kind: String) -> String:
	var base := "draw_%s_" % kind
	var n := 1
	if editor.ctx.data and editor.ctx.data.drawings:
		for d in editor.ctx.data.drawings:
			if d is Resource and d.has_method("get"):
				var did := String(d.id)
				if did.begins_with(base):
					var tail := did.trim_prefix(base)
					var num := int(tail)
					if num >= n:
						n = num + 1
	return "%s%03d" % [base, n]
