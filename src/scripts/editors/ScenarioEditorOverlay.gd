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
## Scale modifier when hovered
@export var hover_scale: float = 1.15
## Offset of entity title when hovered
@export var hover_title_offset: Vector2 = Vector2(0, 40)

const MI_CONFIG_SLOT := 1001

var _icon_cache := {}
var _ctx: PopupMenu
var _last_pick: Dictionary = {}
var _hover_pick: Dictionary = {}
var _hover_pos: Vector2 = Vector2.ZERO

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	visible = true
	
	_ctx = PopupMenu.new()
	add_child(_ctx)
	_ctx.id_pressed.connect(_on_ctx_pressed)

func _draw() -> void:
	_draw_units()
	_draw_slots()

	if editor and editor.current_tool:
		editor.current_tool.draw_overlay(self)

func request_redraw() -> void:
	queue_redraw()

func on_ctx_open(event: InputEventMouseButton):
	if not event: return
	_last_pick = _pick_at(event.position)

	_ctx.clear()
	_ctx.add_item("Map", -1)
	_ctx.set_item_disabled(0, true)
	_ctx.add_separator()

	if _last_pick.get("type", &"") == &"slot":
		_ctx.add_item("Configure Slot…", MI_CONFIG_SLOT)
	else:
		_ctx.add_item("No actions here", -1)
		_ctx.set_item_disabled(_ctx.get_item_count() - 1, true)

	_ctx.position = event.position.floor()
	_ctx.reset_size()
	_ctx.popup()

func on_dbl_click(event: InputEventMouseButton):
	if not event: return
	var pick := _pick_at(event.position)
	match pick.get("type", &""):
		&"slot":
			editor._open_slot_config(pick["index"])
		_:
			pass

func on_mouse_move(pos: Vector2) -> void:
	_hover_pos = pos
	_hover_pick = _pick_at(pos)
	queue_redraw()

func _on_ctx_pressed(id: int) -> void:
	match id:
		MI_CONFIG_SLOT:
			if _last_pick.get("type", &"") == &"slot":
				editor._open_slot_config(_last_pick["index"])

func _draw_units() -> void:
	if not editor or not editor.data or not editor.data.terrain or editor.data.units == null:
		return
	for i in editor.data.units.size():
		var su = editor.data.units[i]
		if su == null or su.unit == null: 
			continue
		var tex := _get_scaled_icon_unit(su)
		if tex == null: 
			continue
		var pos: Vector2 = editor.terrain_render.terrain_to_map(su.position_m)
		var hovered: bool = _hover_pick.get("type", &"") == &"unit" and _hover_pick.get("index", -1) == i
		_draw_icon_with_hover(tex, pos, hovered)
		if hovered:
			_draw_title(su.unit.title, pos)

## Draw placed UnitSlotData instances using slot_icon
func _draw_slots() -> void:
	if not editor or not editor.data or not editor.data.terrain or editor.data.unit_slots == null:
		return
	var tex := _get_scaled_icon_slot()
	if tex == null: 
		return
	for i in editor.data.unit_slots.size():
		var entry = editor.data.unit_slots[i]
		var pos_m := _slot_pos_m(entry)
		var pos: Vector2 = editor.terrain_render.terrain_to_map(pos_m)
		var hovered: bool = _hover_pick.get("type", &"") == &"slot" and _hover_pick.get("index", -1) == i
		_draw_icon_with_hover(tex, pos, hovered)
		if hovered:
			var title := "slot"
			if entry is UnitSlotData:
				title = (entry as UnitSlotData).title
			_draw_title(title, pos)

func _draw_icon_with_hover(tex: Texture2D, center: Vector2, hovered: bool) -> void:
	var icon_size: Vector2 = tex.get_size()
	var half := icon_size * 0.5
	if hovered:
		draw_set_transform(center, 0.0, Vector2.ONE * hover_scale)
		draw_texture(tex, -half)
		draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
	else:
		draw_texture(tex, center - half)

func _draw_title(text: String, center: Vector2) -> void:
	var font := get_theme_default_font()
	var fs := get_theme_default_font_size()
	if font == null: return
	var pos := center + hover_title_offset
	var w := font.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, fs).x
	var rect := Rect2(Vector2(pos.x - w * 0.5 - 4, pos.y - fs - 4), Vector2(w + 8, fs + 8))
	draw_rect(rect, Color(0, 0, 0, 0.55), true)
	draw_string(font, Vector2(pos.x - w * 0.5, pos.y), text, HORIZONTAL_ALIGNMENT_LEFT, -1, fs, Color(1,1,1,0.96))

## Returns { type: string/..., index: int } of nearest object under cursor
func _pick_at(overlay_pos: Vector2) -> Dictionary:
	var best := {}
	var best_d2 := INF

	var slot_r := float(slot_icon_px) * 0.5 + 2.0
	if editor and editor.data and editor.data.unit_slots:
		for i in editor.data.unit_slots.size():
			var entry = editor.data.unit_slots[i]
			var pos_m := _slot_pos_m(entry)
			var sp := editor.terrain_render.terrain_to_map(pos_m)
			var d2 := sp.distance_squared_to(overlay_pos)
			if d2 <= slot_r * slot_r and d2 < best_d2:
				best_d2 = d2
				best = { "type": &"slot", "index": i }

	var unit_r := float(unit_icon_px) * 0.5 + 2.0
	if editor and editor.data and editor.data.units:
		for i in editor.data.units.size():
			var su = editor.data.units[i]
			if su == null: continue
			var up := editor.terrain_render.terrain_to_map(su.position_m)
			var d2 := up.distance_squared_to(overlay_pos)
			if d2 <= unit_r * unit_r and d2 < best_d2:
				best_d2 = d2
				best = { "type": &"unit", "index": i }

	return best

## Supports both dict and resource with .start_position or .position_m
func _slot_pos_m(entry) -> Vector2:
	if typeof(entry) == TYPE_DICTIONARY:
		return entry.get("position_m", Vector2.ZERO)
	if "start_position" in entry:
		return entry.start_position
	if "position_m" in entry:
		return entry.position_m
	return Vector2.ZERO

func _get_scaled_icon_unit(u: ScenarioUnit) -> Texture2D:
	var base: Texture2D = null
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
