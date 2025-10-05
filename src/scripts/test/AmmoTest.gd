extends Control

const AMMO_TYPE := "small_arms"
const BURST := 5

# ---- UI refs via $ paths (no Unique required) ----
@onready var _lbl_shooter: Label = $UI/Row1/LblShooter
@onready var _lbl_logi: Label    = $UI/Row1/LblLogi
@onready var _lbl_link: Label    = $UI/Row1/LblLink
@onready var _log: RichTextLabel = $UI/Log

@onready var _btn_fire: Button   = $UI/Row2/BtnFire
@onready var _btn_auto: Button   = $UI/Row2/BtnAutoFire
@onready var _btn_near: Button   = $UI/Row2/BtnNear
@onready var _btn_far: Button    = $UI/Row2/BtnFar
@onready var _btn_reset: Button  = $UI/Row2/BtnReset
@onready var _fire_timer: Timer  = $FireTimer

# ---- runtime nodes ----
var ammo: AmmoSystem
var adapter: CombatAdapter
var profile: AmmoProfile

# ---- test units ----
var shooter: UnitData
var logi: UnitData

# Local position caches (don’t peek into AmmoSystem internals)
var _pos_shooter: Vector3 = Vector3.ZERO
var _pos_logi:    Vector3 = Vector3.ZERO

# initial test values
var _init_shooter_cap := 30
var _init_logi_stock := 200
var _radius := 25.0
var _rate := 20.0

# optional periodic HUD/console tick
var _print_tick: Timer

# test variable for the side panel
var _rearm_panel: AmmoRearmPanel

func _ready() -> void:
	# Runtime-only nodes so nothing leaks into main scenes
	ammo = AmmoSystem.new()
	add_child(ammo)
	ammo.add_to_group("AmmoSystem")

	profile = preload("res://data/ammo/default_caps.tres")
	ammo.ammo_profile = profile

	adapter = CombatAdapter.new()
	adapter.ammo_system_path = ammo.get_path()   # set BEFORE add_child so _ready() binds
	add_child(adapter)
	adapter.fire_blocked_empty.connect(
		func(uid: String, t: String) -> void:
			_print("[BLOCK] %s cannot fire (%s empty)" % [uid, t])
	)

	# Radio-style logs
	ammo.ammo_low.connect(func(uid: String) -> void: _print("[RADIO] %s: Bingo ammo" % uid))
	ammo.ammo_critical.connect(func(uid: String) -> void: _print("[RADIO] %s: Ammo critical" % uid))
	ammo.ammo_empty.connect(func(uid: String) -> void: _print("[RADIO] %s: Winchester" % uid))
	ammo.resupply_started.connect(func(src: String, dst: String) -> void: _print("[RADIO] %s -> %s: Resupplying" % [src, dst]))
	ammo.resupply_completed.connect(func(src: String, dst: String) -> void: _print("[RADIO] %s -> %s: Resupply complete" % [src, dst]))

	# Make the log visible & auto-scrolling
	_enable_log()

	_spawn_units()
	_wire_ui()
	
	_embed_rearm_panel()
	
	_update_hud()
	_update_link_status()

	# optional 1s console/HUD tick (helps verify resupply over time)
	_print_tick = Timer.new()
	_print_tick.wait_time = 1.0
	_print_tick.one_shot = false
	add_child(_print_tick)
	_print_tick.timeout.connect(func() -> void:
		var cur := int(shooter.state_ammunition.get(AMMO_TYPE, 0))
		var cap := int(shooter.ammunition.get(AMMO_TYPE, 0))
		var stock := int(logi.throughput.get(AMMO_TYPE, 0))
		print("[TICK] shooter %d/%d  stock %d" % [cur, cap, stock])
		_update_hud()
	)
	_print_tick.start()

func _physics_process(delta: float) -> void:
	# Harmless even if AmmoSystem also ticks internally.
	ammo.tick(delta)
	_update_link_status()
	_update_hud()  # keep labels live while resupplying

# ---------- setup ----------

func _enable_log() -> void:
	_log.custom_minimum_size = Vector2(0, 180)
	_log.scroll_active = true
	_log.scroll_following = true
	_log.autowrap_mode = TextServer.AUTOWRAP_WORD

func _spawn_units() -> void:
	# Shooter
	shooter = UnitData.new()
	shooter.id = "alpha"
	shooter.title = "Alpha"
	shooter.ammunition = {AMMO_TYPE: _init_shooter_cap}
	shooter.state_ammunition = {AMMO_TYPE: _init_shooter_cap}

	# Logistics unit
	logi = UnitData.new()
	logi.id = "logi1"
	logi.title = "Logistics Truck"
	logi.throughput = {AMMO_TYPE: _init_logi_stock}
	logi.supply_transfer_rate = _rate
	logi.supply_transfer_radius_m = _radius
	logi.equipment_tags = ["LOGISTICS"]

	ammo.register_unit(shooter)
	ammo.register_unit(logi)

	_pos_shooter = Vector3(0, 0, 0)
	_pos_logi    = Vector3(100, 0, 0)   # start out of range

	ammo.set_unit_position(shooter.id, _pos_shooter)
	ammo.set_unit_position(logi.id,    _pos_logi)

func _wire_ui() -> void:
	_btn_fire.pressed.connect(_on_fire_once)
	_btn_auto.pressed.connect(_on_toggle_auto)
	_btn_near.pressed.connect(_on_move_near)
	_btn_far.pressed.connect(_on_move_far)
	_btn_reset.pressed.connect(_on_reset)
	_fire_timer.timeout.connect(_on_fire_once)
	_fire_timer.wait_time = 0.7
	_fire_timer.one_shot = false
	_fire_timer.stop()

# ---------- actions ----------

func _on_fire_once() -> void:
	var ok := adapter.request_fire(shooter.id, AMMO_TYPE, BURST)
	if ok:
		_print("[FIRE] %s -> %s (%d rounds)" % [shooter.id, AMMO_TYPE, BURST])
	_update_hud()

func _on_toggle_auto() -> void:
	if _fire_timer.is_stopped():
		_fire_timer.start()
		_btn_auto.text = "Auto Fire: ON"
	else:
		_fire_timer.stop()
		_btn_auto.text = "Auto Fire"

func _on_move_near() -> void:
	_pos_logi = Vector3(10, 0, 0)   # inside radius
	ammo.set_unit_position(logi.id, _pos_logi)
	_print("[MOVE] %s moved near %s" % [logi.id, shooter.id])
	_update_link_status()

func _on_move_far() -> void:
	_pos_logi = Vector3(100, 0, 0)  # outside radius
	ammo.set_unit_position(logi.id, _pos_logi)
	_print("[MOVE] %s moved far from %s" % [logi.id, shooter.id])
	_update_link_status()

func _on_reset() -> void:
	shooter.ammunition[AMMO_TYPE] = _init_shooter_cap
	shooter.state_ammunition[AMMO_TYPE] = _init_shooter_cap
	logi.throughput[AMMO_TYPE] = _init_logi_stock
	_print("[RESET] ammo and stock restored")
	_update_hud()
	_update_link_status()

# ---------- UI updates ----------

func _update_hud() -> void:
	var scur := int(shooter.state_ammunition.get(AMMO_TYPE, 0))
	var scap := int(shooter.ammunition.get(AMMO_TYPE, 0))
	var stock := int(logi.throughput.get(AMMO_TYPE, 0))
	_lbl_shooter.text = "Shooter %s: %d/%d" % [shooter.id, scur, scap]
	_lbl_logi.text = "Logi %s stock(%s): %d" % [logi.id, AMMO_TYPE, stock]

func _update_link_status() -> void:
	var d: float = _pos_shooter.distance_to(_pos_logi)
	var in_range: bool = d <= max(logi.supply_transfer_radius_m, 0.0)
	var status := "IN RANGE" if in_range else "OUT OF RANGE"
	_lbl_link.text = "Link: distance=%.1fm  (radius=%.1fm)  %s" % [
		d, logi.supply_transfer_radius_m, status
	]

func _print(line: String) -> void:
	print(line)  # Godot output
	_log.append_text(line + "\n")
	call_deferred("_scroll_log_bottom")

func _scroll_log_bottom() -> void:
	if _log.scroll_active:
		_log.scroll_to_line(_log.get_line_count() - 1)
		
		
func _embed_rearm_panel() -> void:
	# Create a horizontal frame and move your existing UI under it,
	# then add the rearm panel on the left.
	var frame := HBoxContainer.new()
	frame.name = "Frame"
	frame.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	frame.size_flags_vertical = Control.SIZE_EXPAND_FILL

	# Grab your current UI node and reparent under the frame
	var ui := $UI
	remove_child(ui)
	add_child(frame)

	# Instance the panel and add it on the left
	_rearm_panel = preload("res://scenes/ui/ammo_rearm_panel.tscn").instantiate() as AmmoRearmPanel
	_rearm_panel.custom_minimum_size = Vector2(300, 0)   # width of the side panel
	_rearm_panel.size_flags_stretch_ratio = 0.28         # keep it slim vs. the main UI

	frame.add_child(_rearm_panel)
	frame.add_child(ui)

	# Ensure the right UI fills remaining space
	ui.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	ui.size_flags_vertical = Control.SIZE_EXPAND_FILL

	# Feed roster + a placeholder depot stock to the panel
	# (use your real mission depot dict if you have one)
	_rearm_panel.load_units([shooter, logi], {"small_arms": 300})

	# When the user commits, update HUD and (optionally) save
	_rearm_panel.rearm_committed.connect(_on_rearm_committed)


func _on_rearm_committed(units_map: Dictionary, depot_after: Dictionary) -> void:
	# units_map example: { "alpha": {"small_arms": 12} }
	_print("[REARM] committed: %s" % [str(units_map)])
	_update_hud()
