extends Control
## Stand-alone test for the Fuel system (panel placed under the test HUD block).

const RX_SPEED_KPH: float = 12.0
const RX_CAP: float = 100.0
const RX_START: float = 35.0

const TK_STOCK_START: int = 400
const TK_RATE: float = 8.0
const TK_RADIUS: float = 30.0

# ---------- UI refs (filled in _wire_ui) ----------
var btn_move: Button
var btn_drain: Button
var btn_tp: Button
var btn_topup: Button
var lbl_rx: Label
var lbl_tk: Label
var lbl_spd: Label
var panel: FuelRefuelPanel

# ---------- Fuel test state ----------
var fuel: FuelSystem
var rx: ScenarioUnit
var tk: ScenarioUnit
var rx_state: UnitFuelState

var move_enabled: bool = false
var depot_stock: float = 300.0

var _last_time_s: float = 0.0
var _prev_pos_rx: Vector2 = Vector2.ZERO
var _ema_speed_rx: float = 0.0


func _ready() -> void:
	_wire_ui()  # resolve HUD nodes if present
	_ensure_panel_below_hud_block()  # <-- put refuel panel under the top HUD

	# FuelSystem
	fuel = FuelSystem.new()
	add_child(fuel)
	fuel.add_to_group("FuelSystem")

	# Receiver
	rx = ScenarioUnit.new()
	rx.id = "rx"
	rx.callsign = "Receiver"
	rx.position_m = Vector2(10, 10)
	rx.unit = UnitData.new()
	rx.unit.id = "rx_unit"
	rx.unit.speed_kph = RX_SPEED_KPH
	rx.unit.strength = 100
	rx.unit.morale = 1.0

	# Tanker / Logistics
	tk = ScenarioUnit.new()
	tk.id = "tk"
	tk.callsign = "Tanker"
	tk.position_m = Vector2(35, 10)
	tk.unit = UnitData.new()
	tk.unit.id = "tk_unit"
	tk.unit.speed_kph = 12.0
	tk.unit.strength = 100
	tk.unit.morale = 1.0
	tk.unit.throughput = {"fuel": TK_STOCK_START}
	tk.unit.supply_transfer_rate = TK_RATE
	tk.unit.supply_transfer_radius_m = TK_RADIUS
	tk.unit.equipment_tags = ["LOGISTICS", "FUEL_TANKER"]

	# Register in FuelSystem
	rx_state = UnitFuelState.new()
	rx_state.fuel_capacity = RX_CAP
	rx_state.state_fuel = RX_START
	fuel.register_scenario_unit(rx, rx_state)
	fuel.register_scenario_unit(tk, UnitFuelState.new())

	# Optional slowdown hook
	if "bind_fuel_system" in rx:
		rx.bind_fuel_system(fuel)
	if "bind_fuel_system" in tk:
		tk.bind_fuel_system(fuel)

	# Wire HUD buttons (guarded)
	if btn_move:
		btn_move.pressed.connect(_on_toggle_move)
	if btn_drain:
		btn_drain.pressed.connect(_on_drain)
	if btn_tp:
		btn_tp.pressed.connect(_on_tp)
	if btn_topup:
		btn_topup.pressed.connect(_on_topup)

	# Panel: always on (like ammo panel)
	if panel:
		panel.visible = true
		panel.open([rx, tk], fuel, depot_stock, "Refuel Units")
		panel.refuel_committed.connect(_on_panel_done, Object.CONNECT_ONE_SHOT)

	_last_time_s = _now_s()
	_prev_pos_rx = rx.position_m
	set_process(true)


func _process(delta: float) -> void:
	if move_enabled:
		var base_mps: float = _kph_to_mps(RX_SPEED_KPH)
		var mult: float = fuel.speed_mult(rx.id)
		rx.position_m.x += base_mps * mult * delta

	fuel.tick(delta)
	_update_labels()


# ---------- UI helpers ----------


func _wire_ui() -> void:
	# Try both hierarchies: with "Pad" and without.
	btn_move = _find_button(
		["CanvasLayer/HUD/Panel/Pad/VBox/Row1/BtnMove", "CanvasLayer/HUD/Panel/VBox/Row1/BtnMove"]
	)
	btn_drain = _find_button(
		["CanvasLayer/HUD/Panel/Pad/VBox/Row1/BtnDrain", "CanvasLayer/HUD/Panel/VBox/Row1/BtnDrain"]
	)
	btn_tp = _find_button(
		[
			"CanvasLayer/HUD/Panel/Pad/VBox/Row1/BtnTeleport",
			"CanvasLayer/HUD/Panel/VBox/Row1/BtnTeleport"
		]
	)
	btn_topup = _find_button(
		["CanvasLayer/HUD/Panel/Pad/VBox/Row2/BtnTopUp", "CanvasLayer/HUD/Panel/VBox/Row2/BtnTopUp"]
	)
	lbl_rx = _find_label(
		["CanvasLayer/HUD/Panel/Pad/VBox/Row3/LblRx", "CanvasLayer/HUD/Panel/VBox/Row3/LblRx"]
	)
	lbl_tk = _find_label(
		["CanvasLayer/HUD/Panel/Pad/VBox/Row3/LblTk", "CanvasLayer/HUD/Panel/VBox/Row3/LblTk"]
	)
	lbl_spd = _find_label(
		["CanvasLayer/HUD/Panel/Pad/VBox/Row4/LblSpd", "CanvasLayer/HUD/Panel/VBox/Row4/LblSpd"]
	)
	# panel is resolved/created below

	if lbl_rx:
		lbl_rx.autowrap_mode = TextServer.AUTOWRAP_WORD
	if lbl_tk:
		lbl_tk.autowrap_mode = TextServer.AUTOWRAP_WORD


# Create/find FuelRefuelPanel and place it **under** the top HUD panel (no overlap).
func _ensure_panel_below_hud_block() -> void:
	var hud := get_node_or_null("CanvasLayer/HUD") as Control
	if hud == null:
		return

	panel = _find_panel(
		[
			"CanvasLayer/HUD/FuelRefuelPanel",
			"CanvasLayer/HUD/Panel/FuelRefuelPanel",
			"CanvasLayer/HUD/Panel/Pad/VBox/FuelRefuelPanel"
		]
	)

	if panel == null:
		var PanelScene : PackedScene = preload("res://scenes/ui/fuel_refuel_panel.tscn")
		panel = PanelScene.instantiate() as FuelRefuelPanel
		panel.name = "FuelRefuelPanel"
		hud.add_child(panel)
	elif panel.get_parent() != hud:
		panel.get_parent().remove_child(panel)
		hud.add_child(panel)

	# place after layout settles
	call_deferred("_position_fuel_panel_below_hud", 110.0, 160.0, 440.0, 10.0)


func _position_fuel_panel_below_hud(
	shift_right: float = 64.0, shift_down: float = 42.0, width: float = 420.0, height: float = 310.0
) -> void:
	var hud := get_node_or_null("CanvasLayer/HUD") as Control
	var ref := get_node_or_null("CanvasLayer/HUD/Panel") as Control  # top HUD block
	if hud == null or panel == null:
		return

	# Base pos/size in HUD-local coordinates.
	var base_pos: Vector2 = Vector2(16.0, 16.0)
	var base_size: Vector2 = Vector2.ZERO
	if ref != null:
		# 'ref' is a direct child of HUD, so .position is already HUD-local.
		base_pos = ref.position
		base_size = ref.size

	# Final placement just under the HUD block, nudged right/down.
	var left: float = base_pos.x + shift_right
	var top: float = base_pos.y + base_size.y + shift_down

	# Lock anchors and set explicit rect (no container influence).
	panel.set_anchors_preset(Control.PRESET_TOP_LEFT)
	panel.anchor_left = 0.0
	panel.anchor_right = 0.0
	panel.anchor_top = 0.0
	panel.anchor_bottom = 0.0
	panel.size_flags_horizontal = 0
	panel.size_flags_vertical = 0

	panel.position = Vector2(left, top)
	panel.size = Vector2(width, height)
	panel.visible = true


func _find_button(paths: PackedStringArray) -> Button:
	for p in paths:
		var n: Node = get_node_or_null(p)
		if n is Button:
			return n as Button
	return null


func _find_label(paths: PackedStringArray) -> Label:
	for p in paths:
		var n: Node = get_node_or_null(p)
		if n is Label:
			return n as Label
	return null


func _find_panel(paths: PackedStringArray) -> FuelRefuelPanel:
	for p in paths:
		var n: Node = get_node_or_null(p)
		if n is FuelRefuelPanel:
			return n as FuelRefuelPanel
	return null


# ---------- HUD update ----------


func _update_labels() -> void:
	if lbl_rx:
		var rdbg: Dictionary = fuel.fuel_debug(rx.id)
		var rx_pct: String = (
			"n/a" if rdbg.get("percent", null) == null else str(int(rdbg["percent"]))
		)
		var rx_mult: float = float(rdbg.get("mult", 1.0))
		var rx_pen: int = int(rdbg.get("penalty_pct", 0))
		var rx_state_tag: String = String(rdbg.get("state", "n/a"))
		lbl_rx.text = (
			"Receiver  %s%% %s  x%.2f (-%d%%)  pos=(%.1f, %.1f)"
			% [rx_pct, rx_state_tag, rx_mult, rx_pen, rx.position_m.x, rx.position_m.y]
		)

	if lbl_tk:
		var stock: int = 0
		if tk.unit.throughput is Dictionary and tk.unit.throughput.has("fuel"):
			stock = int(tk.unit.throughput["fuel"])
		lbl_tk.text = (
			"Tanker    stock=%d   rate=%.1f/s   radius=%.1fm   d=%.1fm"
			% [stock, TK_RATE, TK_RADIUS, rx.position_m.distance_to(tk.position_m)]
		)

	if lbl_spd:
		var now_s: float = _now_s()
		var dt: float = max(1e-6, now_s - _last_time_s)
		_last_time_s = now_s
		var dist: float = rx.position_m.distance_to(_prev_pos_rx)
		_prev_pos_rx = rx.position_m
		var inst: float = dist / dt
		_ema_speed_rx = lerp(_ema_speed_rx, inst, 0.4)
		var rx_mult2: float = fuel.speed_mult(rx.id)
		lbl_spd.text = "Speed  atk=%.2fm/s (EMA)  mult=%.2f" % [_ema_speed_rx, rx_mult2]


# ---------- UI handlers ----------


func _on_toggle_move() -> void:
	move_enabled = !move_enabled
	if btn_move:
		btn_move.text = ("Stop Moving" if move_enabled else "Toggle Move")


func _on_drain() -> void:
	var st: UnitFuelState = fuel.get_fuel_state(rx.id)
	if st != null:
		st.state_fuel = max(0.0, min(st.fuel_capacity, st.fuel_capacity * 0.05))


func _on_tp() -> void:
	tk.position_m = rx.position_m + Vector2(min(TK_RADIUS * 0.5, 10.0), 0.0)


func _on_topup() -> void:
	if tk.unit.throughput is Dictionary:
		var cur: int = int(tk.unit.throughput.get("fuel", 0))
		tk.unit.throughput["fuel"] = cur + 100


func _on_panel_done(_plan: Dictionary, depot_after: float) -> void:
	depot_stock = depot_after
	_update_labels()


# ---------- misc ----------


func _kph_to_mps(kph: float) -> float:
	return max(0.0, kph) * (1000.0 / 3600.0)


func _now_s() -> float:
	return float(Time.get_ticks_msec()) / 1000.0
