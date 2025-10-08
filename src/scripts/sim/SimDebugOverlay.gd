class_name SimDebugOverlay
extends Control
## Simulation debug overlay drawn on top of TerrainRender.
## @brief Shows unit icons, callsigns, last order, planned paths, destinations,
## behaviour/combat mode, strength & morale, and recent combat contacts.
## @experimental
## Shows unit icons, callsigns, last order, planned paths, destinations,
## behaviour/combat mode, strength & morale, and recent combat contacts.
## Attach as a child of `TerrainRender` (same canvas) so drawing aligns.
## @experimental

## --- References -----------------------------------------------------------
@export var debug_enabled: bool = false
@export var terrain_renderer: TerrainRender
@export var _sim: SimWorld
@export var _orders: OrdersRouter
@export var _fuel: FuelSystem

## --- Toggles --------------------------------------------------------------
@export var show_icons := true
@export var show_paths := true
@export var show_destinations := true
@export var show_labels := true
@export var show_orders := true
@export var show_bars := true
@export var show_combat_hot := true
@export var show_fuel := true

## --- Style ----------------------------------------------------------------
@export var icon_size_px := 26
@export var path_width_px := 2.0
@export var dest_radius_px := 6.0
@export var friend_color: Color = Color(0.09, 0.43, 0.78, 1.0)
@export var enemy_color: Color = Color(0.78, 0.16, 0.12, 1.0)
@export var text_color: Color = Color(0.08, 0.08, 0.08, 1.0)
@export var hot_color: Color = Color(0.78, 0.16, 0.12, 1.0)
@export var bar_bg: Color = Color(0, 0, 0, 0.25)
@export var bar_strength: Color = Color(0.12, 0.65, 0.28)
@export var bar_morale: Color = Color(0.16, 0.42, 0.78)
@export var bar_fuel: Color = Color(0.75, 0.65, 0.15)
@export var font_size := 12
@export var label_offset_px := Vector2(0, -24)

## --- Runtime caches -------------------------------------------------------
var _terrain_base: Control  ## TerrainRender/MapMargin/TerrainBase
var _map_tf: Transform2D  ## Base→overlay transform
var _map_rect: Rect2  ## Base rect in overlay-space

var _unit_by_id: Dictionary = {}  ## String → ScenarioUnit
var _last_order: Dictionary = {}  ## String → String (pretty order)
var _recent_contact_until: Dictionary = {}  ## String → float (mission time when cold)


## Auto-wire references, build caches, and connect signals.
func _ready() -> void:
	_terrain_base = terrain_renderer.get_node_or_null("MapMargin/TerrainBase") as Control

	_rebuild_id_index()
	_compute_map_transform()

	# Hook signals (best-effort)
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


## Housekeeping per-frame: fade recent combat markers and request redraws.
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


## Recompute transforms on any host or base resize.
func _on_resized() -> void:
	_compute_map_transform()
	queue_redraw()


## Compute Base→Overlay transform so the overlay aligns with the map area.
func _compute_map_transform() -> void:
	if _terrain_base == null:
		_map_tf = Transform2D.IDENTITY
		_map_rect = Rect2(Vector2.ZERO, size)
		return
	var base_xform := _terrain_base.get_global_transform_with_canvas()
	var my_xform := get_global_transform_with_canvas()
	_map_tf = my_xform.affine_inverse() * base_xform
	_map_rect = Rect2(_map_tf.origin, _terrain_base.size)


## Build id → ScenarioUnit index for quick lookups.
## Build a lookup: unit_id → ScenarioUnit, from ScenarioData.units.
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


## Record last applied order for labels.
## Capture last applied order per unit for display.
func _on_order_applied(order: Dictionary) -> void:
	var uid := str(order.get("unit_id", ""))
	var typ := str(order.get("type", "")).to_upper()
	if uid != "":
		_last_order[uid] = typ
	queue_redraw()


## Also show failed orders (marked ✖) to aid debugging.
func _on_order_failed(order: Dictionary, _reason: String) -> void:
	# Still useful to see what was attempted
	var uid := str(order.get("unit_id", ""))
	var typ := str(order.get("type", "")).to_upper() + " ✖"
	if uid != "":
		_last_order[uid] = typ
	queue_redraw()


## Flag attacker/defender as "hot" for a short period after contact.
func _on_contact(attacker_id: String, defender_id: String) -> void:
	if not show_combat_hot:
		return
	var now := _sim.get_mission_time_s() if _sim else Time.get_ticks_msec() / 1000.0
	_recent_contact_until[attacker_id] = now + 10.0
	_recent_contact_until[defender_id] = now + 10.0
	queue_redraw()


## Redraw on mission state changes (RUNNING/PAUSED/etc.).
func _on_state(_prev, _next) -> void:
	queue_redraw()


## Redraw when units change (position/state snapshots).
func _on_unit_updated(_id: String, _snap: Dictionary) -> void:
	queue_redraw()


## Main draw pass for icons, paths, and labels.
func _draw() -> void:
	if not debug_enabled:
		return

	if terrain_renderer == null or terrain_renderer.data == null:
		return

	var units: Array[ScenarioUnit] = []
	units.append_array(Game.current_scenario.units)
	units.append_array(Game.current_scenario.playable_units)

	# Draw per unit
	for unit in units:
		var pos_m: Vector2 = terrain_renderer.terrain_to_map(unit.position_m)
		var friend := unit.affiliation == ScenarioUnit.Affiliation.FRIEND
		var col := friend_color if friend else enemy_color

		# Planned path
		if show_paths:
			var path_m: PackedVector2Array = unit.current_path()
			if path_m.size() >= 2:
				var poly: PackedVector2Array = []
				for i in path_m:
					poly.append(terrain_renderer.terrain_to_map(i))
				draw_polyline(poly, col, path_width_px, true)

		# Destination
		if show_destinations:
			var dst_m := unit.destination_m()
			if is_finite(dst_m.x) and is_finite(dst_m.y):
				var dpx := terrain_renderer.terrain_to_map(dst_m)
				draw_circle(dpx, dest_radius_px, col)
				draw_arc(dpx, dest_radius_px + 4.0, 0, TAU, 20, col, 1.2)

		# Icon
		if show_icons:
			var tex: Texture2D = unit.unit.icon if friend else unit.unit.enemy_icon
			if tex:
				var half := Vector2(icon_size_px, icon_size_px) * 0.5
				draw_texture_rect(tex, Rect2(pos_m - half, half * 2.0), false)
			else:
				draw_circle(pos_m, icon_size_px * 0.5, col)

		# Labels / bars
		if show_labels or show_bars:
			var y := 0.0
			var last_order_type: int = int(_last_order.get(unit.id, 0))
			var order: String
			if last_order_type > 0:
				order = OrdersParser.OrderType.keys()[last_order_type]
			var order_txt: String = order if show_orders else ""
			var beh := _enum_name(ScenarioUnit.Behaviour, unit.behaviour)
			var cmb := _enum_name(ScenarioUnit.CombatMode, unit.combat_mode)
			var s_ratio := _norm_ratio(unit.unit.state_strength, unit.unit.strength)
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


## Helper: draw a ratio bar with background.
## Draw a ratio bar with background and thin border.
func _draw_bar(tl: Vector2, w: float, h: float, ratio: float, col: Color) -> void:
	ratio = clampf(ratio, 0.0, 1.0)
	draw_rect(Rect2(tl, Vector2(w, h)), bar_bg, true)
	draw_rect(Rect2(tl, Vector2(w * ratio, h)), col, true)
	draw_rect(Rect2(tl, Vector2(w, h)), Color(0, 0, 0, 0.65), false, 1.0)


## Helper: normalize unknown ranges (treat >1 as percent 0..100).
## Normalize unknown ranges (treat >1 as percent 0..100).
func _norm_ratio(v: float, t: float = 100.0) -> float:
	return clampf(v if v <= 1.0 else (v / t), 0.0, 1.0)


## Convert enum value to name (without prefix numbers).
## Convert enum value to a short human label.
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


## Convert ScenarioUnit.MoveState → label.
## Convert ScenarioUnit.MoveState to a compact label.
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
