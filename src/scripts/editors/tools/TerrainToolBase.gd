class_name TerrainToolBase
extends RefCounted

## Base class for terrain editor tools.

@warning_ignore("unused_signal")
signal on_options_changed
@warning_ignore("unused_signal")
signal on_need_info
@warning_ignore("unused_signal")
signal on_hints_changed

var editor: TerrainEditor
var render: TerrainRender
var viewport_container: SubViewportContainer
var viewport: SubViewport
var data: TerrainData
var brushes: Array[TerrainBrush] = []
var features: Array[Variant] = []

var tool_hint := ""
var tool_icon: Texture2D
var _inside := false
var _preview: Control


## Assign Metadata
func _init():
	#tool_icon = preload("")
	tool_hint = "Base Tool"


## Handle viewport input. Return true if consumed.
func handle_view_input(_event: InputEvent) -> bool:
	return false


## Populate options UI.
func build_options_ui(_parent: Control) -> void:
	pass


## Populate info UI.
func build_info_ui(_parent: Control) -> void:
	pass


## Populate hint UI
func build_hint_ui(_parent: Control) -> void:
	pass


## Build tool preview
func build_preview(_parent: Control) -> Control:
	return null


## Ensure the preview exists
func ensure_preview(parent: Control) -> void:
	if _preview == null:
		_preview = build_preview(parent)


## Editor tells the tool the mouse entered/exited the viewport
func on_mouse_inside(inside: bool) -> void:
	_inside = inside
	if is_instance_valid(_preview):
		_preview.visible = inside


## Update preview position on screen
func update_preview_at_screen(screen_pos: Vector2) -> void:
	if not _inside or _preview == null or viewport_container == null or render == null:
		return

	var local_m := editor.screen_to_map(screen_pos, true)
	if not local_m.is_finite():
		return

	_place_preview(local_m)


## Update preview location on viewport
func update_preview_at_overlay(overlay: Control, overlay_pos: Vector2) -> void:
	if not _preview or not render:
		return
	var overlay_to_canvas := overlay.get_global_transform_with_canvas()
	var canvas_pos := overlay_to_canvas * overlay_pos

	var canvas_to_overlay := overlay_to_canvas.affine_inverse()
	var overlay_local := canvas_to_overlay * canvas_pos
	if _preview is Control:
		(_preview as Control).position = overlay_local
		_place_preview(overlay_pos)
		_preview.queue_redraw()


## Where to place the preview and how to feed parameters
func _place_preview(local_px: Vector2) -> void:
	if _preview is Control:
		(_preview as Control).position = local_px
		_preview.queue_redraw()


## Destroy the preview
func destroy_preview() -> void:
	if is_instance_valid(_preview):
		_preview.queue_free()
	_preview = null
