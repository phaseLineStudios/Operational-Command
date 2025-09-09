extends Control
class_name ScenarioEditorOverlay
## Draws editor overlays: placed units, selection, and active tool ghosts.
## The TerrainRender handles map<->terrain transforms; this node just draws.

## Owning editor.
@export var editor: ScenarioEditor

## Icon size for placed units (px).
@export var unit_icon_px: int = 36

var _icon_cache := {}

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	visible = true

func _draw() -> void:
	_draw_units()

	if editor and editor.current_tool:
		editor.current_tool.draw_overlay(self)

func request_redraw() -> void:
	queue_redraw()

func _draw_units() -> void:
	if not editor or not editor.data or not editor.data.terrain:
		return
	if not editor.terrain_render or not editor.terrain_render.has_method("terrain_to_map"):
		return

	for su in editor.data.units:
		if su == null or su.unit == null:
			continue
		var tex := _get_scaled_icon(su.unit)
		if tex == null:
			continue

		var screen_pos: Vector2 = editor.terrain_render.terrain_to_map(su.position_m)
		var icon_size: Vector2 = tex.get_size()
		var half := icon_size * 0.5

		draw_set_transform(screen_pos)
		draw_texture(tex, -half)

		draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)

func _get_scaled_icon(u: UnitData) -> Texture2D:
	var base: Texture2D = u.icon if u.icon else load("res://assets/textures/units/nato_unknown_platoon.png")
	if base == null:
		return null
	var key := "%s:%d" % [u.id, unit_icon_px]
	var cached: Texture2D = _icon_cache.get(key)
	if cached:
		return cached
	var img := base.get_image()
	if img.is_empty():
		return base
	img.resize(unit_icon_px, unit_icon_px, Image.INTERPOLATE_LANCZOS)
	var tex := ImageTexture.create_from_image(img)
	_icon_cache[key] = tex
	return tex
