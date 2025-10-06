extends Control
## Stand-alone test for the Fuel system (robust UI lookup).

# ---------- UI refs (filled in _wire_ui) ----------
var btn_move: Button
var btn_drain: Button
var btn_tp: Button
var btn_topup: Button
var btn_panel: Button
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

const RX_SPEED_KPH: float = 12.0
const RX_CAP: float = 100.0
const RX_START: float = 35.0

const TK_STOCK_START: int = 400
const TK_RATE: float = 8.0
const TK_RADIUS: float = 30.0

func _ready() -> void:
	_wire_ui() # <-- resolve UI nodes regardless of layout

	# Create FuelSystem and group it for auto-discovery by overlays, if any.
	fuel = FuelSystem.new()
	add_child(fuel)
	fuel.add_to_group("FuelSystem")

	# Build a receiver ScenarioUnit
	rx = ScenarioUnit.new()
	rx.id = "rx"
	rx.callsign = "Receiver"
	rx.position_m = Vector2(10, 10)
	rx.unit = UnitData.new()
	rx.unit.id = "rx_unit"
	rx.unit.speed_kph = RX_SPEED_KPH
	rx.unit.strength = 100
	rx.unit.morale = 1.0

	# Build a tanker/logistics ScenarioUnit
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

	# Register in FuelSystem (+ defaults via FuelProfile if present)
	rx_state = UnitFuelState.new()
	rx_state.fuel_capacity = RX_CAP
	rx_state.state_fuel = RX_START
	fuel.register_scenario_unit(rx, rx_state)
	fuel.register_scenario_unit(tk, UnitFuelState.new())

	# Optional slowdown hook if you added bind_fuel_system to ScenarioUnit
	if "bind_fuel_system" in rx: rx.bind_fuel_system(fuel)
	if "bind_fuel_system" in tk: tk.bind_fuel_system(fuel)

	# Wire UI signals (now that nodes are guaranteed non-null)
	btn_move.pressed.connect(_on_toggle_move)
	btn_drain.pressed.connect(_on_drain)
	btn_tp.pressed.connect(_on_tp)
	btn_topup.pressed.connect(_on_topup)
	btn_panel.pressed.connect(_on_open_panel)

	# Init speed calc
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
	btn_move  = _find_button(["CanvasLayer/HUD/Panel/Pad/VBox/Row1/BtnMove", "CanvasLayer/HUD/Panel/VBox/Row1/BtnMove"])
	btn_drain = _find_button(["CanvasLayer/HUD/Panel/Pad/VBox/Row1/BtnDrain","CanvasLayer/HUD/Panel/VBox/Row1/BtnDrain"])
	btn_tp    = _find_button(["CanvasLayer/HUD/Panel/Pad/VBox/Row1/BtnTeleport","CanvasLayer/HUD/Panel/VBox/Row1/BtnTeleport"])
	btn_topup = _find_button(["CanvasLayer/HUD/Panel/Pad/VBox/Row2/BtnTopUp","CanvasLayer/HUD/Panel/VBox/Row2/BtnTopUp"])
	btn_panel = _find_button(["CanvasLayer/HUD/Panel/Pad/VBox/Row2/BtnPanel","CanvasLayer/HUD/Panel/VBox/Row2/BtnPanel"])
	lbl_rx    = _find_label (["CanvasLayer/HUD/Panel/Pad/VBox/Row3/LblRx","CanvasLayer/HUD/Panel/VBox/Row3/LblRx"])
	lbl_tk    = _find_label (["CanvasLayer/HUD/Panel/Pad/VBox/Row3/LblTk","CanvasLayer/HUD/Panel/VBox/Row3/LblTk"])
	lbl_spd   = _find_label (["CanvasLayer/HUD/Panel/Pad/VBox/Row4/LblSpd","CanvasLayer/HUD/Panel/VBox/Row4/LblSpd"])
	panel     = _find_panel (["CanvasLayer/HUD/FuelRefuelPanel"]) # instance path unchanged

	# Guard rails: fail fast with a clear message if the scene differs.
	assert(btn_move  != null, "BtnMove not found; check TestFuel.tscn hierarchy.")
	assert(btn_drain != null, "BtnDrain not found; check TestFuel.tscn hierarchy.")
	assert(btn_tp    != null, "BtnTeleport not found; check TestFuel.tscn hierarchy.")
	assert(btn_topup != null, "BtnTopUp not found; check TestFuel.tscn hierarchy.")
	assert(btn_panel != null, "BtnPanel not found; check TestFuel.tscn hierarchy.")
	assert(lbl_rx    != null, "LblRx not found; check TestFuel.tscn hierarchy.")
	assert(lbl_tk    != null, "LblTk not found; check TestFuel.tscn hierarchy.")
	assert(lbl_spd   != null, "LblSpd not found; check TestFuel.tscn hierarchy.")
	assert(panel     != null, "FuelRefuelPanel instance missing from HUD.")

	# Nice-to-have: wrapping for long text
	lbl_rx.autowrap_mode = TextServer.AUTOWRAP_WORD
	lbl_tk.autowrap_mode = TextServer.AUTOWRAP_WORD

func _find_button(paths: PackedStringArray) -> Button:
	for p in paths:
		var n := get_node_or_null(p)
		if n is Button: return n
	return null

func _find_label(paths: PackedStringArray) -> Label:
	for p in paths:
		var n := get_node_or_null(p)
		if n is Label: return n
	return null

func _find_panel(paths: PackedStringArray) -> FuelRefuelPanel:
	for p in paths:
		var n := get_node_or_null(p)
		if n is FuelRefuelPanel: return n
	return null

# ---------- HUD update ----------

func _update_labels() -> void:
	var rdbg: Dictionary = fuel.fuel_debug(rx.id)
	var rx_pct: String = ("n/a" if rdbg.get("percent", null) == null else str(int(rdbg["percent"])))
	var rx_mult: float = float(rdbg.get("mult", 1.0))
	var rx_pen: int = int(rdbg.get("penalty_pct", 0))
	var rx_state_tag: String = String(rdbg.get("state", "n/a"))

	lbl_rx.text = "Receiver  %s%% %s  x%.2f (-%d%%)  pos=(%.1f, %.1f)" % [
		rx_pct, rx_state_tag, rx_mult, rx_pen, rx.position_m.x, rx.position_m.y
	]

	var stock: int = 0
	if tk.unit.throughput is Dictionary and tk.unit.throughput.has("fuel"):
		stock = int(tk.unit.throughput["fuel"])
	lbl_tk.text = "Tanker    stock=%d   rate=%.1f/s   radius=%.1fm   d=%.1fm" % [
		stock, TK_RATE, TK_RADIUS, rx.position_m.distance_to(tk.position_m)
	]

	var now_s: float = _now_s()
	var dt: float = max(1e-6, now_s - _last_time_s)
	_last_time_s = now_s
	var dist: float = rx.position_m.distance_to(_prev_pos_rx)
	_prev_pos_rx = rx.position_m
	var inst: float = dist / dt
	_ema_speed_rx = lerp(_ema_speed_rx, inst, 0.4)

	lbl_spd.text = "Speed  atk=%.2fm/s (EMA)  mult=%.2f" % [_ema_speed_rx, rx_mult]

# ---------- UI handlers ----------

func _on_toggle_move() -> void:
	move_enabled = !move_enabled
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

func _on_open_panel() -> void:
	panel.open([rx, tk], fuel, depot_stock, "Refuel Units")
	panel.refuel_committed.connect(_on_panel_done, Object.CONNECT_ONE_SHOT)

func _on_panel_done(_plan: Dictionary, depot_after: float) -> void:
	depot_stock = depot_after
	_update_labels()

# ---------- misc ----------

func _kph_to_mps(kph: float) -> float:
	return max(0.0, kph) * (1000.0 / 3600.0)

func _now_s() -> float:
	return float(Time.get_ticks_msec()) / 1000.0
