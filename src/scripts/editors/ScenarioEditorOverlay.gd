extends Control
class_name ScenarioEditorOverlay
## Draws editor overlays: placed units, selection, and active tool ghosts.
## The TerrainRender handles map<->terrain transforms; this node just draws.

## Owning editor.
@export var editor: ScenarioEditor
## Icon size for placed units (px).
@export var unit_icon_px: int = 36
## Icon size for placed slots (px)
@export var slot_icon_px: int = 36
## Slot Icon texture
@export var slot_icon: Texture2D = preload("res://assets/textures/units/slot_icon.png")

var _icon_cache := {}

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	visible = true

func _draw() -> void:
	_draw_units()
	_draw_slots()

	if editor and editor.current_tool:
		editor.current_tool.draw_overlay(self)

func request_redraw() -> void:
	queue_redraw()

func _draw_units() -> void:
	if not editor or not editor.data or not editor.data.terrain:
		return

	for su in editor.data.units:
		if su == null or su.unit == null:
			continue
		var tex := _get_scaled_icon_unit(su)
		if tex == null:
			continue

		var screen_pos: Vector2 = editor.terrain_render.terrain_to_map(su.position_m)
		var icon_size: Vector2 = tex.get_size()
		var half := icon_size * 0.5

		draw_set_transform(screen_pos)
		draw_texture(tex, -half)

		draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)

## Draw placed UnitSlotData instances using slot_icon
func _draw_slots() -> void:
	if not editor or not editor.data or not editor.data.terrain:
		return

	var tex := _get_scaled_icon_slot()
	if tex == null:
		return

	for entry in editor.data.unit_slots:
		var screen_pos: Vector2 = editor.terrain_render.terrain_to_map(entry.start_position)
		var icon_size: Vector2 = tex.get_size()
		var half := icon_size * 0.5
		draw_texture(tex, screen_pos - half)

func _get_scaled_icon_unit(u: ScenarioUnit) -> Texture2D:
	var base: Texture2D = null
	print(u.affiliation)
	if u and u.unit:
		if ScenarioUnit.Affiliation.friend == u.affiliation:
			base = u.unit.icon if u.unit.icon else null
		else:
			base = u.unit.enemy_icon if u.unit.enemy_icon else null
	if base == null:
		if ScenarioUnit.Affiliation.friend == u.affiliation:
			base = load("res://assets/textures/units/nato_unknown_platoon.png")
		else:
			base = load("res://assets/textures/units/enemy_unknown_platoon.png")
	var key := "UNIT:%s:%d:%d" % [u.unit.id, unit_icon_px, u.affiliation]
	return _scaled_cached(key, base, unit_icon_px)

func _get_scaled_icon_slot() -> Texture2D:
	var key := "SLOT:%d" % slot_icon_px
	return _scaled_cached(key, slot_icon, slot_icon_px)

func _scaled_cached(key: String, base: Texture2D, px: int) -> Texture2D:
	var cached: Texture2D = _icon_cache.get(key)
	if cached: return cached
	if base == null: return null
	var img := base.get_image()
	if img.is_empty(): return base
	img.resize(px, px, Image.INTERPOLATE_LANCZOS)
	var tex := ImageTexture.create_from_image(img)
	_icon_cache[key] = tex
	return tex
