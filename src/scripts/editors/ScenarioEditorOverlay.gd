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

const MI_CONFIG_SLOT := 1001

var _icon_cache := {}
var _ctx: PopupMenu
var _last_pick: Dictionary = {}

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
	# Build pick info at cursor (overlay-local pos).
	_last_pick = _pick_at(event.position)

	_ctx.clear()
	# Header (disabled)
	_ctx.add_item("Map", -1)
	_ctx.set_item_disabled(0, true)
	_ctx.add_separator()

	# Slot-specific item if a slot is under the cursor.
	if _last_pick.get("type", &"") == &"slot":
		_ctx.add_item("Configure Slot…", MI_CONFIG_SLOT)
	else:
		# Optional: generic items later (add/remove markers, etc.)
		_ctx.add_item("No actions here", -1)
		_ctx.set_item_disabled(_ctx.get_item_count() - 1, true)

	# Position menu at click point (overlay coords).
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
			pass # extend for units/triggers later

func _on_ctx_pressed(id: int) -> void:
	match id:
		MI_CONFIG_SLOT:
			if _last_pick.get("type", &"") == &"slot":
				editor._open_slot_config(_last_pick["index"])

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

## Returns { type: "slot"/..., index: int } of nearest object under cursor
func _pick_at(overlay_pos: Vector2) -> Dictionary:
	var best := {}
	var best_d2 := INF

	var slot_r := float(slot_icon_px) * 0.5 + 2.0
	if editor and editor.data and editor.data.unit_slots:
		for i in editor.data.unit_slots.size():
			var entry = editor.data.unit_slots[i]
			var pos_m := _slot_pos_m(entry)
			var screen := editor.terrain_render.terrain_to_map(pos_m)
			var d2 := screen.distance_squared_to(overlay_pos)
			if d2 <= slot_r * slot_r and d2 < best_d2:
				best_d2 = d2
				best = { "type": &"slot", "index": i }

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
