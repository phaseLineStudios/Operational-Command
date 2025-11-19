class_name SimDebugOverlay
extends Control
## Simulation debug overlay drawn on top of TerrainRender.
##
## Renders unit icons, paths, destinations, labels (order/behaviour/
## combat mode), strength/morale/fuel bars, and recent combat highlights.
## Attach as a child of `TerrainRender` so drawing aligns with the map.
## @experimental

## Master toggle; when false the overlay does not process or draw.
@export var debug_enabled: bool:
	get:
		return _debug_enabled
	set(value):
		_debug_enabled = value
		visible = value
		set_process(value)
		queue_redraw()
## Terrain renderer used for map/terrain coordinate transforms.
@export var terrain_renderer: TerrainRender
## Simulation world for unit snapshots and mission timing.
@export var _sim: SimWorld
## Orders router to show last applied order per unit.
@export var _orders: OrdersRouter
## Fuel system to display fuel state bars.
@export var _fuel: FuelSystem

@export_group("Features")
## Show unit icons.
@export var show_icons := true
## Show planned movement paths.
@export var show_paths := true
## Show unit destination rings.
@export var show_destinations := true
## Show text labels (callsign/order/behaviour/combat/ratios).
@export var show_labels := true
## Include last applied order in labels.
@export var show_orders := true
## Show strength/morale (and fuel) bars under icons.
@export var show_bars := true
## Highlight units recently in contact.
@export var show_combat_hot := true
## Show fuel percentage (when available).
@export var show_fuel := true
## Draw red lines between engaged pairs.
@export var show_combat_lines := true

@export_group("Style")
## Icon size in pixels (square).
@export var icon_size_px := 26
## Path stroke width in pixels.
@export var path_width_px := 2.0
## Destination ring radius in pixels.
@export var dest_radius_px := 6.0
## Friendly color.
@export var friend_color: Color = Color(0.09, 0.43, 0.78, 1.0)
## Enemy color.
@export var enemy_color: Color = Color(0.78, 0.16, 0.12, 1.0)
## Label text color.
@export var text_color: Color = Color(0.08, 0.08, 0.08, 1.0)
## “Hot” label color for recent combat.
@export var hot_color: Color = Color(0.78, 0.16, 0.12, 1.0)
## Bar background color.
@export var bar_bg: Color = Color(0, 0, 0, 0.25)
## Strength bar color.
@export var bar_strength: Color = Color(0.12, 0.65, 0.28)
## Morale bar color.
@export var bar_morale: Color = Color(0.16, 0.42, 0.78)
## Fuel bar color.
@export var bar_fuel: Color = Color(0.75, 0.65, 0.15)
## Label font size (pixels).
@export var font_size := 12
## Label offset from icon center (pixels).
@export var label_offset_px := Vector2(0, -24)
## Combat line stroke width (pixels).
@export var combat_line_width_px := 2.5
## Combat line color.
@export var combat_line_color: Color = Color(0.90, 0.08, 0.08, 0.95)
## Alpha for dead units' icons.
@export var dead_icon_alpha := 0.35

var _terrain_base: Control
var _map_tf: Transform2D
var _map_rect: Rect2

var _unit_by_id: Dictionary = {}
var _last_order: Dictionary = {}
var _recent_contact_until: Dictionary = {}

var _debug_enabled: bool = false


## Auto-wire references, build caches, connect signals, and set processing.
func _ready() -> void:
	# Ensure this overlay never blocks mouse/keyboard interaction with the scene
	mouse_filter = MOUSE_FILTER_IGNORE
	# Keep visibility aligned with the master toggle to avoid intercepting events
	visible = debug_enabled
	_terrain_base = terrain_renderer.get_node_or_null("MapMargin/TerrainBase") as Control

	_rebuild_id_index()
	_compute_map_transform()

	if _sim:
		if not _sim.is_connected("unit_updated", Callable(self, "_on_unit_updated")):
			_sim.unit_updated.connect(_on_unit_updated)
		if not _sim.is_connected("engagement_reported", Callable(self, "_on_contact")):
			_sim.engagement_reported.connect(_on_contact)
		if not _sim.is_connected("mission_state_changed", Callable(self, "_on_state")):
			_sim.mission_state_changed.connect(_on_state)
	if _orders:
		_orders.order_applied.connect(_on_order_applied)
		_orders.order_failed.connect(_on_order_failed)
	if terrain_renderer:
		terrain_renderer.connect("resized", Callable(self, "_on_resized"))
		terrain_renderer.connect("map_resize", Callable(self, "_on_resized"))
	if _terrain_base:
		_terrain_base.connect("resized", Callable(self, "_on_resized"))

	set_process(debug_enabled)


## Fade recent-combat markers and request redraws while enabled.
## [param _dt] Delta time (seconds).
func _process(_dt: float) -> void:
	if show_combat_hot and _sim:
		var now := _sim.get_mission_time_s()
		var changed := false
		for uid in _recent_contact_until.keys():
			if now >= float(_recent_contact_until[uid]):
				_recent_contact_until.erase(uid)
				changed = true
		if changed:
			queue_redraw()

	queue_redraw()


## Recompute transforms when map or base resizes.
func _on_resized() -> void:
	_compute_map_transform()
	queue_redraw()


## Compute the Base -> Overlay transform so overlay drawing aligns with the map.
func _compute_map_transform() -> void:
	if _terrain_base == null:
		_map_tf = Transform2D.IDENTITY
		_map_rect = Rect2(Vector2.ZERO, size)
		return
	var base_xform := _terrain_base.get_global_transform_with_canvas()
	var my_xform := get_global_transform_with_canvas()
	_map_tf = my_xform.affine_inverse() * base_xform
	_map_rect = Rect2(_map_tf.origin, _terrain_base.size)


## Build unit_id -> ScenarioUnit lookup from the current scenario.
func _rebuild_id_index() -> void:
	_unit_by_id.clear()
	var scen := Game.current_scenario
	if scen == null:
		return
	for su in scen.units:
		if su != null:
			_unit_by_id[su.id] = su
	for su in scen.playable_units:
		if su != null:
			_unit_by_id[su.id] = su


## Record the last applied order per unit for label display.
## [param order] Order dictionary that was applied.
func _on_order_applied(order: Dictionary) -> void:
	var uid := str(order.get("unit_id", ""))
	var typ := str(order.get("type", "")).to_upper()
	if uid != "":
		_last_order[uid] = typ
	queue_redraw()


## Record failed order attempts (marked ✖) to aid debugging.
## [param order] Order dictionary that failed.
## [param _reason] Failure reason (unused here).
func _on_order_failed(order: Dictionary, _reason: String) -> void:
	var uid := str(order.get("unit_id", ""))
	var typ := str(order.get("type", "")).to_upper() + " ✖"
	if uid != "":
		_last_order[uid] = typ
	queue_redraw()


## Mark attacker/defender as “hot” for a short period after combat.
## [param attacker_id] Attacker unit id.
## [param defender_id] Defender unit id.
func _on_contact(attacker_id: String, defender_id: String, _damage: float = 0.0) -> void:
	if not show_combat_hot:
		return
	var now := _sim.get_mission_time_s() if _sim else Time.get_ticks_msec() / 1000.0
	_recent_contact_until[attacker_id] = now + 10.0
	_recent_contact_until[defender_id] = now + 10.0
	queue_redraw()


## Request redraw when mission state changes (e.g. RUNNING/PAUSED).
func _on_state(_prev, _next) -> void:
	queue_redraw()


## Request redraw when a unit snapshot updates.
func _on_unit_updated(_id: String, _snap: Dictionary) -> void:
	queue_redraw()


## Draw icons, paths, destinations, labels, and bars for all units.
func _draw() -> void:
	if not debug_enabled:
		return

	if terrain_renderer == null or terrain_renderer.data == null:
		return

	if show_combat_lines and _sim:
		var pairs: Array = []
		if _sim.has_method("get_current_contacts"):
			pairs = _sim.get_current_contacts()
		for p in pairs:
			var aid := str(p.get("attacker", ""))
			var did := str(p.get("defender", ""))
			var a_su: ScenarioUnit = _unit_by_id.get(aid)
			var d_su: ScenarioUnit = _unit_by_id.get(did)
			if a_su == null or d_su == null:
				continue
			if a_su.is_dead() or d_su.is_dead():
				continue
			var a_px := terrain_renderer.terrain_to_map(a_su.position_m)
			var d_px := terrain_renderer.terrain_to_map(d_su.position_m)
			draw_line(a_px, d_px, combat_line_color, combat_line_width_px)

	var units: Array[ScenarioUnit] = []
	units.append_array(Game.current_scenario.units)
	units.append_array(Game.current_scenario.playable_units)

	for unit in units:
		var pos_m: Vector2 = terrain_renderer.terrain_to_map(unit.position_m)
		var friend := unit.affiliation == ScenarioUnit.Affiliation.FRIEND
		var col := friend_color if friend else enemy_color

		if show_paths:
			var path_m: PackedVector2Array = unit.current_path()
			if path_m.size() >= 2:
				var poly: PackedVector2Array = []
				for i in path_m:
					poly.append(terrain_renderer.terrain_to_map(i))
				draw_polyline(poly, col, path_width_px, true)

		if show_destinations:
			var dst_m := unit.destination_m()
			if is_finite(dst_m.x) and is_finite(dst_m.y):
				var dpx := terrain_renderer.terrain_to_map(dst_m)
				draw_circle(dpx, dest_radius_px, col)
				draw_arc(dpx, dest_radius_px + 4.0, 0, TAU, 20, col, 1.2)

		if show_icons:
			var tex: Texture2D = unit.unit.icon if friend else unit.unit.enemy_icon
			if tex:
				var half := Vector2(icon_size_px, icon_size_px) * 0.5
				var mod := Color(1, 1, 1, dead_icon_alpha if unit.is_dead() else 1.0)
				draw_texture_rect(tex, Rect2(pos_m - half, half * 2.0), false, mod)
			else:
				var c := col
				if unit.is_dead():
					c.a *= dead_icon_alpha
				draw_circle(pos_m, icon_size_px * 0.5, c)

		if show_labels or show_bars:
			var y := 0.0
			var last_order_type: int = int(_last_order.get(unit.id, 0))
			var order: String
			if last_order_type > 0:
				order = OrdersParser.OrderType.keys()[last_order_type]
			var order_txt: String = order if show_orders else ""
			var beh := _enum_name(ScenarioUnit.Behaviour, unit.behaviour)
			var cmb := _enum_name(ScenarioUnit.CombatMode, unit.combat_mode)
			var s_ratio := _norm_ratio(unit.state_strength, unit.unit.strength)
			var m_ratio := _norm_ratio(unit.unit.morale)
			var fuel_ratio := (
				_fuel.get_fuel_state(unit.id).ratio()
				if show_fuel and _fuel and _fuel.get_fuel_state(unit.id)
				else -1.0
			)

			if show_labels:
				var hot := show_combat_hot and _recent_contact_until.has(unit.id)
				var lbl := (
					"%s  %s  [%s/%s]  S:%d%%  M:%d%%"
					% [
						unit.callsign,
						order_txt if order_txt != "" else _state_name(int(unit.move_state())),
						beh,
						cmb,
						int(roundi(s_ratio * 100.0)),
						int(roundi(m_ratio * 100.0))
					]
				)
				if fuel_ratio >= 0.0:
					lbl += "  F:%d%%" % roundi(fuel_ratio * 100.0)
				draw_set_transform(pos_m + label_offset_px)
				draw_string(
					get_theme_default_font(),
					Vector2.ZERO,
					lbl,
					HORIZONTAL_ALIGNMENT_LEFT,
					-1.0,
					font_size,
					hot_color if hot else text_color
				)
				draw_set_transform(Vector2(0, 0))

			if show_bars:
				var bar_w := 54.0
				var bar_h := 5.0
				var gap := 2.0
				var top := pos_m + Vector2(-bar_w * 0.5, icon_size_px * 0.5 + 4.0)
				_draw_bar(top, bar_w, bar_h, s_ratio, bar_strength)
				top.y += bar_h + gap
				_draw_bar(top, bar_w, bar_h, m_ratio, bar_morale)
				if fuel_ratio >= 0.0:
					top.y += bar_h + gap
					_draw_bar(top, bar_w, bar_h, fuel_ratio, bar_fuel)


## Draw a ratio bar with background and thin border.
## [param tl] Top-left in overlay pixels.
## [param w] Width (px).
## [param h] Height (px).
## [param ratio] Fill ratio [0..1].
## [param col] Fill color.
func _draw_bar(tl: Vector2, w: float, h: float, ratio: float, col: Color) -> void:
	ratio = clampf(ratio, 0.0, 1.0)
	draw_rect(Rect2(tl, Vector2(w, h)), bar_bg, true)
	draw_rect(Rect2(tl, Vector2(w * ratio, h)), col, true)
	draw_rect(Rect2(tl, Vector2(w, h)), Color(0, 0, 0, 0.65), false, 1.0)


## Normalize values; treat values >1 as percentages using [param t] as max.
## [param v] Input value (0..1 or 0..t).
## [param t] Maximum when v is in “percent-like” scale (default 100).
## [return] Ratio clamped to [0, 1].
func _norm_ratio(v: float, t: float = 100.0) -> float:
	return clampf(v if v <= 1.0 else (v / t), 0.0, 1.0)


## Convert enum value to a short human label.
## [param _enum] Enum type marker.
## [param value] Enum value.
## [return] Short label string.
func _enum_name(_enum: Variant, value: int) -> String:
	match _enum:
		ScenarioUnit.Behaviour:
			match value:
				ScenarioUnit.Behaviour.CARELESS:
					return "Careless"
				ScenarioUnit.Behaviour.SAFE:
					return "Safe"
				ScenarioUnit.Behaviour.AWARE:
					return "Aware"
				ScenarioUnit.Behaviour.COMBAT:
					return "Combat"
				ScenarioUnit.Behaviour.STEALTH:
					return "Stealth"
		ScenarioUnit.CombatMode:
			match value:
				ScenarioUnit.CombatMode.FORCED_HOLD_FIRE:
					return "Hold"
				ScenarioUnit.CombatMode.DO_NOT_FIRE_UNLESS_FIRED_UPON:
					return "Return"
				ScenarioUnit.CombatMode.OPEN_FIRE:
					return "Open"
	return str(value)


## Convert ScenarioUnit.MoveState to a compact label.
## [param s] MoveState enum value.
## [return] Short label string.
func _state_name(s: int) -> String:
	match s:
		ScenarioUnit.MoveState.IDLE:
			return "IDLE"
		ScenarioUnit.MoveState.PLANNING:
			return "PLAN"
		ScenarioUnit.MoveState.MOVING:
			return "MOVE"
		ScenarioUnit.MoveState.PAUSED:
			return "PAUSE"
		ScenarioUnit.MoveState.BLOCKED:
			return "BLOCK"
		ScenarioUnit.MoveState.ARRIVED:
			return "ARRIVE"
		_:
			return str(s)
