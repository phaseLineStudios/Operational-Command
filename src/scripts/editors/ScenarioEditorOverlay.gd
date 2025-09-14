extends Control
class_name ScenarioEditorOverlay
## Draws editor overlays: placed units, selection, and active tool ghosts.
## The TerrainRender handles map<->terrain transforms; this node just draws.

## Owning editor.
@export var editor: ScenarioEditor
## Icon size for placed units (px).
@export var unit_icon_px: int = 48
## Icon size for placed slots (px)
@export var slot_icon_px: int = 48
## Icon size for placed tasks (px)
@export var task_icon_px: int = 48
## Icon Size for inner task icons (px)
@export var task_icon_inner_px: int = 28
## Slot Icon texture
@export var slot_icon: Texture2D = preload("res://assets/textures/units/slot_icon.png")
## Scale modifier when hovered
@export var hover_scale: float = 1.15
## Offset of entity title when hovered
@export var hover_title_offset: Vector2 = Vector2(0, 48)
## Extra pixel gap between link and glyph edge
@export var link_gap_px: float = 3.0
## Arrow head length in pixels
@export var arrow_head_len_px: float = 10.0

const MI_CONFIG_SLOT := 1001
const MI_CONFIG_UNIT := 1002
const MI_CONFIG_TASK := 1003

var _icon_cache := {}
var _ctx: PopupMenu
var _last_pick: Dictionary = {}
var _selected_pick: Dictionary = {} 
var _hover_pick: Dictionary = {}
var _hover_pos: Vector2 = Vector2.ZERO

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	visible = true
	
	_ctx = PopupMenu.new()
	add_child(_ctx)
	_ctx.id_pressed.connect(_on_ctx_pressed)

func _draw() -> void:
	_draw_task_links()
	_draw_units()
	_draw_slots()
	_draw_tasks()

	if editor and editor.current_tool:
		editor.current_tool.draw_overlay(self)

func request_redraw() -> void:
	queue_redraw()

## Editor sets current selection here
func set_selected(pick: Dictionary) -> void:
	_selected_pick = pick if pick != null else {}
	queue_redraw()

func clear_selected() -> void:
	_selected_pick = {}
	queue_redraw()

## Let editor query the thing under a given overlay position
func get_pick_at(pos: Vector2) -> Dictionary:
	return _pick_at(pos)

func on_ctx_open(event: InputEventMouseButton):
	if not event: return
	_last_pick = _pick_at(event.position)

	_ctx.clear()
	_ctx.add_item("Map", -1)
	_ctx.set_item_disabled(0, true)
	_ctx.add_separator()

	match _last_pick.get("type", &""):
		&"slot":
			_ctx.add_item("Configure Slot", MI_CONFIG_SLOT)
		&"unit":
			_ctx.add_item("Configure Unit", MI_CONFIG_UNIT)
		&"task": 
			_ctx.add_item("Configure Task", MI_CONFIG_TASK)
		_:
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
		&"unit":
			editor._open_unit_config(pick["index"])
		&"task": 
			editor._open_task_config(pick["index"])
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
		MI_CONFIG_UNIT:
			if _last_pick.get("type", &"") == &"unit":
				editor._open_unit_config(_last_pick["index"])
		MI_CONFIG_TASK: 
			if _last_pick.get("type","") == "task": 
				editor._open_task_config(_last_pick["index"])

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
		var hi := _is_highlighted(&"unit", i) 
		_draw_icon_with_hover(tex, pos, hi)
		if hi:
			_draw_title(su.callsign, pos)

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
		var hi := _is_highlighted(&"slot", i)
		_draw_icon_with_hover(tex, pos, hi)
		if hi:
			var title := "slot"
			if entry is UnitSlotData:
				title = (entry as UnitSlotData).title
			_draw_title(title, pos)

func _draw_tasks() -> void:
	if not editor or not editor.data or editor.data.tasks == null:
		return
	for i in editor.data.tasks.size():
		var inst: ScenarioTask = editor.data.tasks[i]
		if inst == null: continue
		var p := editor.terrain_render.terrain_to_map(inst.position_m)
		var hi := _is_highlighted(&"task", i)
		_draw_task_glyph(inst, p, hi)

## Draw arrow from previous to each task
func _draw_task_links() -> void:
	if not editor or not editor.data or editor.data.tasks == null:
		return

	for i in editor.data.tasks.size():
		var inst: ScenarioTask = editor.data.tasks[i]
		if inst == null:
			continue

		var src_center: Vector2
		var src_radius := 0.0
		if inst.prev_index >= 0 and inst.prev_index < editor.data.tasks.size():
			var prev: ScenarioTask = editor.data.tasks[inst.prev_index]
			if prev == null:
				continue
			src_center = editor.terrain_render.terrain_to_map(prev.position_m)
			src_radius = _glyph_radius(&"task", inst.prev_index)
		else:
			if inst.unit_index < 0 or inst.unit_index >= editor.data.units.size():
				continue
			var su: ScenarioUnit = editor.data.units[inst.unit_index]
			src_center = editor.terrain_render.terrain_to_map(su.position_m)
			src_radius = _glyph_radius(&"unit", inst.unit_index)

		var dst_center := editor.terrain_render.terrain_to_map(inst.position_m)
		var dst_radius := _glyph_radius(&"task", i)

		var a_b := _trim_segment(
			src_center, dst_center,
			src_radius + link_gap_px,
			dst_radius + link_gap_px
		)
		var a := a_b[0]
		var b := a_b[1]

		if a.distance_to(b) < 2.0:
			continue

		var col := inst.task.color if inst.task else Color.CYAN
		_draw_arrow(a, b, col, arrow_head_len_px)

func _is_highlighted(t: StringName, idx: int) -> bool:
	return (_hover_pick.get("type", &"") == t and _hover_pick.get("index", -1) == idx) \
		or (_selected_pick.get("type", &"") == t and _selected_pick.get("index", -1) == idx)

func _draw_icon_with_hover(tex: Texture2D, center: Vector2, hovered: bool) -> void:
	var icon_size: Vector2 = tex.get_size()
	var half := icon_size * 0.5
	if hovered:
		draw_set_transform(center, 0.0, Vector2.ONE * hover_scale)
		draw_texture(tex, -half)
		draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
	else:
		draw_texture(tex, center - half, Color(1,1,1,0.75))

func _draw_title(text: String, center: Vector2) -> void:
	var font := get_theme_default_font()
	var fs := get_theme_default_font_size()
	if font == null: return
	var pos := center + hover_title_offset
	var w := font.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, fs).x
	var rect := Rect2(Vector2(pos.x - w * 0.5 - 4, pos.y - fs - 4), Vector2(w + 8, fs + 8))
	draw_rect(rect, Color(0, 0, 0, 0.55), true)
	draw_string(font, Vector2(pos.x - w * 0.5, pos.y), text, HORIZONTAL_ALIGNMENT_LEFT, -1, fs, Color(1,1,1,0.96))

func _draw_task_glyph(inst: ScenarioTask, center: Vector2, hi: bool) -> void:
	if inst == null or inst.task == null:
		return
	var to_map := Callable(editor.terrain_render, "terrain_to_map")
	var scale_icon := Callable(self, "_scale_icon")
	inst.task.draw_glyph(self, center, hi, hover_scale, task_icon_px, task_icon_inner_px, inst, to_map, scale_icon)
	if hi and inst.task:
		_draw_title(inst.task.display_name, center)

func _draw_arrow(a: Vector2, b: Vector2, col: Color, head_len: float = arrow_head_len_px) -> void:
	draw_line(a, b, col, 2.0, true)
	var dir := (b - a).normalized()
	var side := dir.rotated(0.8) * head_len
	var side2 := dir.rotated(-0.8) * head_len
	draw_line(b, b - side, col, 2.0, true)
	draw_line(b, b - side2, col, 2.0, true)

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
	
	var task_r := float(task_icon_px) * 0.5 + 4.0
	if editor and editor.data and editor.data.tasks:
		for i in editor.data.tasks.size():
			var inst: ScenarioTask = editor.data.tasks[i]
			if inst == null: continue
			var tp := editor.terrain_render.terrain_to_map(inst.position_m)
			var d2 := tp.distance_squared_to(overlay_pos)
			if d2 <= task_r * task_r and d2 < best_d2:
				best_d2 = d2
				best = { "type": &"task", "index": i }

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

func _get_scaled_icon_task(inst: ScenarioTask) -> Texture2D:
	if not inst or not inst.task or not inst.task.icon:
		return null
	var base: Texture2D = inst.task.icon
	var key := "TASK:%s:%s:%d" % [
		String(inst.task.type_id),
		String(inst.task.resource_path),
		task_icon_inner_px
	]
	return _scaled_cached(key, base, task_icon_inner_px)

func _scale_icon(tex: Texture2D, key: String, px: int) -> Texture2D:
	return _scaled_cached(key, tex, px)

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

## Approximate visual radius (px) for different overlay entities
func _glyph_radius(kind: StringName, idx: int) -> float:
	match kind:
		&"task":
			return float(task_icon_px) * 0.5 * (hover_scale if _is_highlighted(&"task", idx) else 1.0)
		&"unit":
			return float(unit_icon_px) * 0.5 * (hover_scale if _is_highlighted(&"task", idx) else 1.0)
		&"slot":
			return float(slot_icon_px) * 0.5 * (hover_scale if _is_highlighted(&"task", idx) else 1.0)
		_:
			return 0.0

## Shorten segment ends by src_trim and dst_trim (px). Returns [a, b].
func _trim_segment(src: Vector2, dst: Vector2, src_trim: float, dst_trim: float) -> Array[Vector2]:
	var dir := dst - src
	var L := dir.length()
	if L <= 1.0:
		return [src, dst]
	var n := dir / L
	var a := src + n * src_trim
	var b := dst - n * dst_trim
	return [a, b]
