class_name ScenarioEditorOverlay
extends Control
## Draws editor overlays: placed units, selection, and active tool ghosts.
## The TerrainRender handles map<->terrain transforms; this node just draws.

## Context menu id: open slot configuration
const MI_CONFIG_SLOT := 1001
## Context menu id: open unit configuration
const MI_CONFIG_UNIT := 1002
## Context menu id: open task configuration
const MI_CONFIG_TASK := 1003
## Context menu id: open trigger configuration
const MI_CONFIG_TRIGGER := 1004
## Context menu id: delete picked entity
const MI_DELETE := 1099

## Owning editor reference (provides ctx, data, and services)
@export var editor: ScenarioEditor
## Pixel size of unit icons on the overlay
@export var unit_icon_px: int = 48
## Pixel size of player slot icons on the overlay
@export var slot_icon_px: int = 48
## Pixel size of outer task glyphs on the overlay
@export var task_icon_px: int = 48
## Pixel size of inner task glyph icons
@export var task_icon_inner_px: int = 28
## Pixel size of trigger center icon
@export var trigger_icon_px: int = 48
## Trigger area fill color (semi-transparent)
@export var trigger_fill: Color = Color(Color.LIGHT_SKY_BLUE, 0.25)
## Trigger area outline color
@export var trigger_outline: Color = Color(Color.DEEP_SKY_BLUE, 0.9)
## Color for synchronization link lines
@export var sync_line_color: Color = Color(Color.BLACK, 0.5)
## Width in pixels for synchronization link lines
@export var sync_line_width: float = 2.0
## Texture used for slot icons
@export var slot_icon: Texture2D = preload("res://assets/textures/units/slot_icon.png")
## Scale multiplier for hovered glyphs
@export var hover_scale: float = 1.15
## Screen-space offset for hover title labels
@export var hover_title_offset: Vector2 = Vector2(0, 48)
## Extra pixel gap between link line and glyph edge
@export var link_gap_px: float = 3.0
## Arrow head length (pixels) for link arrows
@export var arrow_head_len_px: float = 10.0

var _tex_cache: Dictionary = {}
var _icon_cache := {}
var _ctx: PopupMenu
var _last_pick: Dictionary = {}
var _selected_pick: Dictionary = {}
var _hover_pick: Dictionary = {}
var _hover_pos: Vector2 = Vector2.ZERO

var _link_preview_active := false
var _link_preview_src: Dictionary = {}
var _link_preview_pos := Vector2.ZERO


## Initialize popup menu and mouse handling
func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	visible = true

	_ctx = PopupMenu.new()
	add_child(_ctx)
	_ctx.id_pressed.connect(_on_ctx_pressed)


## Main overlay draw: links first, then glyphs, then active tool
func _draw() -> void:
	_draw_drawings()
	_draw_task_links()
	_draw_sync_links()
	_draw_units()
	_draw_slots()
	_draw_tasks()
	_draw_triggers()

	if _link_preview_active:
		var a := _screen_pos_for_pick(_link_preview_src)
		var b := _link_preview_pos
		draw_line(a, b, sync_line_color, sync_line_width, true)

	# draw active tool ghosts (use the SAME ref you checked)
	if editor and editor.ctx and editor.ctx.current_tool:
		editor.ctx.current_tool.draw_overlay(self)


## Request a redraw of the overlay
func request_redraw() -> void:
	queue_redraw()


## Set current selection highlight
func set_selected(pick: Dictionary) -> void:
	_selected_pick = pick if pick != null else {}
	queue_redraw()


## Clear current selection highlight
func clear_selected() -> void:
	_selected_pick = {}
	queue_redraw()


## Return the closest pickable entity under the given screen position
func get_pick_at(pos: Vector2) -> Dictionary:
	return _pick_at(pos)


## Open context menu at mouse position using current pick
func on_ctx_open(event: InputEventMouseButton):
	if not event:
		return
	_last_pick = _pick_at(event.position)

	_ctx.clear()
	_ctx.add_item("Map", -1)
	_ctx.set_item_disabled(0, true)
	_ctx.add_separator()

	match _last_pick.get("type", &""):
		&"slot":
			_ctx.add_item("Configure Slot", MI_CONFIG_SLOT)
			_ctx.add_separator()
			_ctx.add_item("Delete", MI_DELETE)
		&"unit":
			_ctx.add_item("Configure Unit", MI_CONFIG_UNIT)
			_ctx.add_separator()
			_ctx.add_item("Delete", MI_DELETE)
		&"task":
			_ctx.add_item("Configure Task", MI_CONFIG_TASK)
			_ctx.add_separator()
			_ctx.add_item("Delete", MI_DELETE)
		&"trigger":
			_ctx.add_item("Configure Trigger", MI_CONFIG_TRIGGER)
			_ctx.add_separator()
			_ctx.add_item("Delete", MI_DELETE)
		_:
			_ctx.add_item("No actions here", -1)
			_ctx.set_item_disabled(_ctx.get_item_count() - 1, true)

	_ctx.position = event.position.floor()
	_ctx.reset_size()
	_ctx.popup()


## Handle double-click on a glyph (open config)
func on_dbl_click(event: InputEventMouseButton):
	if not event:
		return
	var pick := _pick_at(event.position)
	match pick.get("type", &""):
		&"slot":
			editor.menus.open_slot_config(pick["index"])
		&"unit":
			editor.menus.open_unit_config(pick["index"])
		&"task":
			editor.menus.open_task_config(pick["index"])
		&"trigger":
			editor.menus.open_trigger_config(pick["index"])
		_:
			pass


## Update hover state and schedule redraw
func on_mouse_move(pos: Vector2) -> void:
	_hover_pos = pos
	_hover_pick = _pick_at(pos)
	queue_redraw()


## Handle context menu actions for the last pick
func _on_ctx_pressed(id: int) -> void:
	match id:
		MI_CONFIG_SLOT:
			if _last_pick.get("type", &"") == &"slot":
				editor.menus.open_slot_config(_last_pick["index"])
		MI_CONFIG_UNIT:
			if _last_pick.get("type", &"") == &"unit":
				editor.menus.open_unit_config(_last_pick["index"])
		MI_CONFIG_TASK:
			if _last_pick.get("type", &"") == &"task":
				editor.menus.open_task_config(_last_pick["index"])
		MI_CONFIG_TRIGGER:
			if _last_pick.get("type", &"") == &"trigger":
				editor.menus.open_trigger_config(_last_pick["index"])
		MI_DELETE:
			if not _last_pick.is_empty():
				editor.deletion_ops.delete_pick(_last_pick)


## Draw all unit glyphs and hover titles
func _draw_units() -> void:
	if (
		not editor
		or not editor.ctx
		or not editor.ctx.data
		or not editor.ctx.data.terrain
		or editor.ctx.data.units == null
	):
		return
	for i in editor.ctx.data.units.size():
		var su: ScenarioUnit = editor.ctx.data.units[i]
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


## Draw all player slot glyphs and hover titles
func _draw_slots() -> void:
	if (
		not editor
		or not editor.ctx
		or not editor.ctx.data
		or not editor.ctx.data.terrain
		or editor.ctx.data.unit_slots == null
	):
		return
	var tex := _get_scaled_icon_slot()
	if tex == null:
		return
	for i in editor.ctx.data.unit_slots.size():
		var entry = editor.ctx.data.unit_slots[i]
		var pos_m := _slot_pos_m(entry)
		var pos: Vector2 = editor.terrain_render.terrain_to_map(pos_m)
		var hi := _is_highlighted(&"slot", i)
		_draw_icon_with_hover(tex, pos, hi)
		if hi:
			var title := "slot"
			if entry is UnitSlotData:
				title = (entry as UnitSlotData).title
			_draw_title(title, pos)


## Draw all task glyphs and hover titles
func _draw_tasks() -> void:
	if not editor or not editor.ctx or not editor.ctx.data or editor.ctx.data.tasks == null:
		return
	for i in editor.ctx.data.tasks.size():
		var inst: ScenarioTask = editor.ctx.data.tasks[i]
		if inst == null:
			continue
		var p := editor.terrain_render.terrain_to_map(inst.position_m)
		var hi := _is_highlighted(&"task", i)
		_draw_task_glyph(inst, p, hi)


## Draw task chain arrows between unit/task and next task
func _draw_task_links() -> void:
	if not editor or not editor.ctx or not editor.ctx.data or editor.ctx.data.tasks == null:
		return

	for i in editor.ctx.data.tasks.size():
		var inst: ScenarioTask = editor.ctx.data.tasks[i]
		if inst == null:
			continue

		var src_center := Vector2.ZERO
		var src_radius := 0.0
		if inst.prev_index >= 0 and inst.prev_index < editor.ctx.data.tasks.size():
			var prev: ScenarioTask = editor.ctx.data.tasks[inst.prev_index]
			if prev == null:
				continue
			src_center = editor.terrain_render.terrain_to_map(prev.position_m)
			src_radius = _glyph_radius(&"task", inst.prev_index)
		else:
			if inst.unit_index < 0 or inst.unit_index >= editor.ctx.data.units.size():
				continue
			var su: ScenarioUnit = editor.ctx.data.units[inst.unit_index]
			src_center = editor.terrain_render.terrain_to_map(su.position_m)
			src_radius = _glyph_radius(&"unit", inst.unit_index)

		var dst_center := editor.terrain_render.terrain_to_map(inst.position_m)
		var dst_radius := _glyph_radius(&"task", i)

		var a_b := _trim_segment(
			src_center, dst_center, src_radius + link_gap_px, dst_radius + link_gap_px
		)
		var a := a_b[0]
		var b := a_b[1]
		if a.distance_to(b) < 2.0:
			continue

		var col := inst.task.color if inst.task else Color.CYAN
		_draw_arrow(a, b, col, arrow_head_len_px)


## Draw trigger areas (circle/rect), outlines, and optional icon/title
func _draw_triggers() -> void:
	if not editor or not editor.ctx or not editor.ctx.data or editor.ctx.data.triggers == null:
		return
	for i in editor.ctx.data.triggers.size():
		var trig: ScenarioTrigger = editor.ctx.data.triggers[i]
		if trig == null:
			continue
		var center_px := editor.terrain_render.terrain_to_map(trig.area_center_m)
		var hi := _is_highlighted(&"trigger", i)
		_draw_trigger_shape(trig, center_px, hi)
		if hi and trig.title != "":
			_draw_title(trig.title, center_px)


## Draw a single trigger's shape + icon with hover colors
func _draw_trigger_shape(trig: ScenarioTrigger, center_px: Vector2, hi: bool) -> void:
	var fill := trigger_fill
	var line := trigger_outline
	var tex := _get_scaled_icon_trigger(trig)
	if hi:
		fill = Color(fill, min(1.0, fill.a + 0.15))
		line = line.lightened(0.15)

	if trig.area_shape == ScenarioTrigger.AreaShape.CIRCLE:
		var r_m: float = max(trig.area_size_m.x, trig.area_size_m.y) * 0.5
		var edge_px := editor.terrain_render.terrain_to_map(trig.area_center_m + Vector2(r_m, 0.0))
		var r_px := edge_px.distance_to(center_px)
		draw_circle(center_px, r_px, fill)
		draw_arc(center_px, r_px, 0.0, TAU, 64, line, 2.0, true)
	else:
		var hx_m := trig.area_size_m.x * 0.5
		var hy_m := trig.area_size_m.y * 0.5
		var p_x := editor.terrain_render.terrain_to_map(trig.area_center_m + Vector2(hx_m, 0.0))
		var p_y := editor.terrain_render.terrain_to_map(trig.area_center_m + Vector2(0.0, hy_m))
		var half_w_px: float = abs(p_x.x - center_px.x)
		var half_h_px: float = abs(p_y.y - center_px.y)
		var rect := Rect2(
			Vector2(center_px.x - half_w_px, center_px.y - half_h_px),
			Vector2(half_w_px * 2.0, half_h_px * 2.0)
		)
		draw_rect(rect, fill, true)
		draw_rect(rect, line, false, 2.0)
	if tex:
		var p := editor.terrain_render.terrain_to_map(trig.area_center_m)
		_draw_icon_with_hover(tex, p, hi)


## Draw all synchronization lines from triggers to units/tasks
func _draw_sync_links() -> void:
	if not editor or not editor.ctx or not editor.ctx.data or editor.ctx.data.triggers == null:
		return
	for trig: ScenarioTrigger in editor.ctx.data.triggers:
		if trig == null:
			continue
		var tp := editor.terrain_render.terrain_to_map(trig.area_center_m)
		if trig.synced_units:
			for ui in trig.synced_units:
				if editor.ctx.data.units and ui >= 0 and ui < editor.ctx.data.units.size():
					var su: ScenarioUnit = editor.ctx.data.units[ui]
					if su:
						var up := editor.terrain_render.terrain_to_map(su.position_m)
						draw_line(up, tp, sync_line_color, sync_line_width, true)
		if trig.synced_tasks:
			for ti in trig.synced_tasks:
				if editor.ctx.data.tasks and ti >= 0 and ti < editor.ctx.data.tasks.size():
					var inst: ScenarioTask = editor.ctx.data.tasks[ti]
					if inst:
						var p := editor.terrain_render.terrain_to_map(inst.position_m)
						draw_line(p, tp, sync_line_color, sync_line_width, true)


## Begin live link line preview from a source pick
func begin_link_preview(src_pick: Dictionary) -> void:
	_link_preview_active = true
	_link_preview_src = src_pick
	queue_redraw()


## Update live link preview endpoint (mouse)
func update_link_preview(mouse_pos: Vector2) -> void:
	_link_preview_pos = mouse_pos
	if _link_preview_active:
		queue_redraw()


## End live link preview and clear state
func end_link_preview() -> void:
	_link_preview_active = false
	_link_preview_src = {}
	queue_redraw()


## Return on-screen center of a given pick (fallback to hover pos)
func _screen_pos_for_pick(pick: Dictionary) -> Vector2:
	var t := StringName(pick.get("type", ""))
	var idx := int(pick.get("index", -1))
	if not editor or not editor.ctx or not editor.ctx.data:
		return _hover_pos
	match t:
		&"unit":
			if (
				editor.ctx.data.units
				and idx >= 0
				and idx < editor.ctx.data.units.size()
				and editor.ctx.data.units[idx]
			):
				return editor.terrain_render.terrain_to_map(editor.ctx.data.units[idx].position_m)
		&"slot":
			if (
				editor.ctx.data.unit_slots
				and idx >= 0
				and idx < editor.ctx.data.unit_slots.size()
				and editor.ctx.data.unit_slots[idx]
			):
				return editor.terrain_render.terrain_to_map(
					editor.ctx.data.unit_slots[idx].start_position
				)
		&"task":
			if (
				editor.ctx.data.tasks
				and idx >= 0
				and idx < editor.ctx.data.tasks.size()
				and editor.ctx.data.tasks[idx]
			):
				return editor.terrain_render.terrain_to_map(editor.ctx.data.tasks[idx].position_m)
		&"trigger":
			if (
				editor.ctx.data.triggers
				and idx >= 0
				and idx < editor.ctx.data.triggers.size()
				and editor.ctx.data.triggers[idx]
			):
				return editor.terrain_render.terrain_to_map(
					editor.ctx.data.triggers[idx].area_center_m
				)
	return _hover_pos


## Check if a glyph of type/index is hovered or selected
func _is_highlighted(t: StringName, idx: int) -> bool:
	return (
		(_hover_pick.get("type", &"") == t and _hover_pick.get("index", -1) == idx)
		or (_selected_pick.get("type", &"") == t and _selected_pick.get("index", -1) == idx)
	)


## Draw scenario drawings (strokes and stamps).
func _draw_drawings() -> void:
	if not editor or not editor.ctx or not editor.ctx.data:
		return
	var arr: Array = editor.ctx.data.drawings
	if arr == null or arr.is_empty():
		return
	var sorted := arr.duplicate()
	sorted.sort_custom(
		func(a, b):
			var la: int = a.layer if a is Resource else int(a.get("layer"))
			var lb: int = b.layer if b is Resource else int(b.get("layer"))
			if la != lb:
				return la < lb
			var oa: int = a.order if a is Resource else int(a.get("order"))
			var ob: int = b.order if b is Resource else int(b.get("order"))
			return oa < ob
	)

	for it in sorted:
		if it == null:
			continue
		if it is ScenarioDrawingStroke:
			if not it.visible or it.points_m.is_empty():
				continue
			var col: Color = it.color
			col.a *= it.opacity
			var last_px := Vector2.INF
			for p_m in it.points_m:
				var p_px := editor.terrain_render.terrain_to_map(p_m)
				if last_px.is_finite():
					draw_line(last_px, p_px, col, it.width_px, true)
				last_px = p_px
		elif it is ScenarioDrawingStamp:
			if not it.visible:
				continue
			var tex := _get_tex(it.texture_path)
			if tex:
				var pos_px := editor.terrain_render.terrain_to_map(it.position_m)
				var sz: Vector2 = tex.get_size() * it.scale
				var tint: Color = it.modulate
				tint.a *= it.opacity
				draw_set_transform(pos_px, deg_to_rad(it.rotation_deg))
				draw_texture_rect(tex, Rect2(-sz * 0.5, sz), false, tint)
				draw_set_transform(Vector2(0, 0))


## Draw a texture centered, with hover scale/opacity feedback
func _draw_icon_with_hover(tex: Texture2D, center: Vector2, hovered: bool) -> void:
	var icon_size: Vector2 = tex.get_size()
	var half := icon_size * 0.5
	if hovered:
		draw_set_transform(center, 0.0, Vector2.ONE * hover_scale)
		draw_texture(tex, -half)
		draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
	else:
		draw_texture(tex, center - half, Color(1, 1, 1, 0.75))


## Draw a small label next to a glyph
func _draw_title(text: String, center: Vector2) -> void:
	var font := get_theme_default_font()
	var fs := get_theme_default_font_size()
	if font == null:
		return
	var pos := center + hover_title_offset
	var w := font.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, fs).x
	var rect := Rect2(Vector2(pos.x - w * 0.5 - 4, pos.y - fs - 4), Vector2(w + 8, fs + 8))
	draw_rect(rect, Color(0, 0, 0, 0.55), true)
	draw_string(
		font,
		Vector2(pos.x - w * 0.5, pos.y),
		text,
		HORIZONTAL_ALIGNMENT_LEFT,
		-1,
		fs,
		Color(1, 1, 1, 0.96)
	)


## Delegate task glyph drawing to the task resource
func _draw_task_glyph(inst: ScenarioTask, center: Vector2, hi: bool) -> void:
	if inst == null or inst.task == null:
		return
	var to_map := Callable(editor.terrain_render, "terrain_to_map")
	var scale_icon := Callable(self, "_scale_icon")
	inst.task.draw_glyph(
		self, center, hi, hover_scale, task_icon_px, task_icon_inner_px, inst, to_map, scale_icon
	)
	if hi and inst.task:
		_draw_title(inst.task.display_name, center)


## Draw an arrow line with two head strokes
func _draw_arrow(a: Vector2, b: Vector2, col: Color, head_len: float = arrow_head_len_px) -> void:
	draw_line(a, b, col, 2.0, true)
	var dir := (b - a).normalized()
	var side := dir.rotated(0.8) * head_len
	var side2 := dir.rotated(-0.8) * head_len
	draw_line(b, b - side, col, 2.0, true)
	draw_line(b, b - side2, col, 2.0, true)


## Hit-test the closest entity under the overlay position
func _pick_at(overlay_pos: Vector2) -> Dictionary:
	var best := {}
	var best_d2 := INF

	var slot_r := float(slot_icon_px) * 0.5 + 2.0
	if editor and editor.ctx and editor.ctx.data and editor.ctx.data.unit_slots:
		for i in editor.ctx.data.unit_slots.size():
			var entry = editor.ctx.data.unit_slots[i]
			if entry == null:
				continue
			var pos_m := _slot_pos_m(entry)
			var sp := editor.terrain_render.terrain_to_map(pos_m)
			var d2 := sp.distance_squared_to(overlay_pos)
			if d2 <= slot_r * slot_r and d2 < best_d2:
				best_d2 = d2
				best = {"type": &"slot", "index": i}

	var unit_r := float(unit_icon_px) * 0.5 + 2.0
	if editor and editor.ctx and editor.ctx.data and editor.ctx.data.units:
		for i in editor.ctx.data.units.size():
			var su: ScenarioUnit = editor.ctx.data.units[i]
			if su == null:
				continue
			var up := editor.terrain_render.terrain_to_map(su.position_m)
			var d2 := up.distance_squared_to(overlay_pos)
			if d2 <= unit_r * unit_r and d2 < best_d2:
				best_d2 = d2
				best = {"type": &"unit", "index": i}

	var task_r := float(task_icon_px) * 0.5 + 4.0
	if editor and editor.ctx and editor.ctx.data and editor.ctx.data.tasks:
		for i in editor.ctx.data.tasks.size():
			var inst: ScenarioTask = editor.ctx.data.tasks[i]
			if inst == null:
				continue
			var tp := editor.terrain_render.terrain_to_map(inst.position_m)
			var d2 := tp.distance_squared_to(overlay_pos)
			if d2 <= task_r * task_r and d2 < best_d2:
				best_d2 = d2
				best = {"type": &"task", "index": i}

	var trig_r := float(trigger_icon_px) * 0.5 + 4.0
	if editor and editor.ctx and editor.ctx.data and editor.ctx.data.triggers:
		for i in editor.ctx.data.triggers.size():
			var trig: ScenarioTrigger = editor.ctx.data.triggers[i]
			if trig == null:
				continue
			var tp := editor.terrain_render.terrain_to_map(trig.area_center_m)
			var d2 := tp.distance_squared_to(overlay_pos)
			if d2 <= trig_r * trig_r and d2 < best_d2:
				best_d2 = d2
				best = {"type": &"trigger", "index": i}

	return best


## Extract slot world position from either dict or resource
func _slot_pos_m(entry) -> Vector2:
	if typeof(entry) == TYPE_DICTIONARY:
		return entry.get("position_m", Vector2.ZERO)
	if "start_position" in entry:
		return entry.start_position
	if "position_m" in entry:
		return entry.position_m
	return Vector2.ZERO


## Get (and cache) a scaled unit icon respecting affiliation
func _get_scaled_icon_unit(u: ScenarioUnit) -> Texture2D:
	var base: Texture2D = null
	if u and u.unit:
		if ScenarioUnit.Affiliation.FRIEND == u.affiliation:
			base = u.unit.icon if u.unit.icon else null
		else:
			base = u.unit.enemy_icon if u.unit.enemy_icon else null
	if base == null:
		base = load(
			(
				"res://assets/textures/units/nato_unknown_platoon.png"
				if ScenarioUnit.Affiliation.FRIEND == u.affiliation
				else "res://assets/textures/units/enemy_unknown_platoon.png"
			)
		)
	var id_str := u.unit.id if u and u.unit and u.unit.id else "unknown"
	var key := "UNIT:%s:%d:%d" % [id_str, unit_icon_px, u.affiliation]
	return _scaled_cached(key, base, unit_icon_px)


## Get (and cache) the scaled slot icon
func _get_scaled_icon_slot() -> Texture2D:
	var key := "SLOT:%d" % slot_icon_px
	return _scaled_cached(key, slot_icon, slot_icon_px)


## Get (and cache) the scaled inner task icon
func _get_scaled_icon_task(inst: ScenarioTask) -> Texture2D:
	if not inst or not inst.task or not inst.task.icon:
		return null
	var base: Texture2D = inst.task.icon
	var key := (
		"TASK:%s:%s:%d"
		% [String(inst.task.type_id), String(inst.task.resource_path), task_icon_inner_px]
	)
	return _scaled_cached(key, base, task_icon_inner_px)


## Get (and cache) the scaled trigger center icon
func _get_scaled_icon_trigger(trig: ScenarioTrigger) -> Texture2D:
	if trig.icon == null:
		return null
	var rpath := String(trig.icon.resource_path)
	var key := "TRIGGER:%s:%d" % [rpath, trigger_icon_px]
	return _scaled_cached(key, trig.icon, trigger_icon_px)


## Utility used by task glyphs to request scaled textures
func _scale_icon(tex: Texture2D, key: String, px: int) -> Texture2D:
	return _scaled_cached(key, tex, px)


## Scale and cache a texture by key and target pixel size
func _scaled_cached(key: String, base: Texture2D, px: int) -> Texture2D:
	var cached: Texture2D = _icon_cache.get(key)
	if cached:
		return cached
	if base == null:
		return null
	var img := base.get_image()
	if img.is_empty():
		return base
	img.resize(px, px, Image.INTERPOLATE_LANCZOS)
	var tex := ImageTexture.create_from_image(img)
	_icon_cache[key] = tex
	return tex


## Load or fetch cached texture.
## [param path] res:// path.
## [return] Texture2D or null.
func _get_tex(path: String) -> Texture2D:
	if path == "":
		return null
	if _tex_cache.has(path) and is_instance_valid(_tex_cache[path]):
		return _tex_cache[path]
	var t: Texture2D = load(path)
	if t:
		_tex_cache[path] = t
	return t


## Return approximate visual radius for a glyph kind/index
func _glyph_radius(kind: StringName, idx: int) -> float:
	match kind:
		&"task":
			return (
				float(task_icon_px) * 0.5 * (hover_scale if _is_highlighted(&"task", idx) else 1.0)
			)
		&"unit":
			return (
				float(unit_icon_px) * 0.5 * (hover_scale if _is_highlighted(&"unit", idx) else 1.0)
			)
		&"slot":
			return (
				float(slot_icon_px) * 0.5 * (hover_scale if _is_highlighted(&"slot", idx) else 1.0)
			)
		_:
			return 0.0


## Shorten a segment at both ends by given trims (pixels)
func _trim_segment(src: Vector2, dst: Vector2, src_trim: float, dst_trim: float) -> Array[Vector2]:
	var dir := dst - src
	var l := dir.length()
	if l <= 1.0:
		return [src, dst]
	var n := dir / l
	var a := src + n * src_trim
	var b := dst - n * dst_trim
	return [a, b]
