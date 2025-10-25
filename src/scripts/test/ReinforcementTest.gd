class_name ReinforcementTest
extends Node2D
## Test harness that:
## - Starts the pool at 10 (and syncs with Game if present)
## - Wires Reset to restore a baseline
## - Optionally auto-applies a sample plan
## - Tests SimWorld spawning (filters wiped-out, applies strength factor)
## - Tests casualty application at debrief time (via MissionResolution helper)

const PANEL_SCENE: PackedScene = preload("res://scenes/ui/unit_mgmt/reinforcement_panel.tscn")

const START_POOL := 10
const AUTO_APPLY := false  # auto-apply the sample plan at startup
const RUN_SPAWN_TEST := true  # exercise SimWorld.spawn_scenario_units()
const RUN_CASUALTY_TEST := true  # exercise MissionResolution.apply_casualties_to_units()

var _units: Array[UnitData] = []
var _panel: ReinforcementPanel
var _pool: int = START_POOL

# Baseline snapshot taken AFTER initial setup
var _baseline_strengths: Dictionary = {}  # { unit_id: int }
var _baseline_pool: int = START_POOL


func _ready() -> void:
	# Demo units
	_units = _make_demo_units()

	# Seed Game's pool first (if autoload exists)
	var g: Node = get_tree().get_root().get_node_or_null("/root/Game")
	if g:
		if g.has_method("set_replacement_pool"):
			g.set_replacement_pool(START_POOL)
		elif g.has_variable("campaign_replacement_pool"):
			g.campaign_replacement_pool = START_POOL

	# Build panel and wait a frame so onready nodes exist
	_panel = PANEL_SCENE.instantiate() as ReinforcementPanel
	add_child(_panel)
	await get_tree().process_frame

	# Initial pool (prefer Game's value)
	if g:
		if g.has_method("get_replacement_pool"):
			_pool = int(g.get_replacement_pool())
		elif g.has_variable("campaign_replacement_pool"):
			_pool = int(g.campaign_replacement_pool)
	else:
		_pool = START_POOL

	# Configure panel (initial view)
	_panel.set_units(_units)
	_panel.set_pool(_pool)
	_panel.reset_pending()

	# ---- run optional tests BEFORE capturing the baseline ----
	if RUN_SPAWN_TEST:
		_test_spawn()

	if RUN_CASUALTY_TEST:
		_test_casualties()

	# Ensure panel reflects any mutations from tests, then snapshot
	_panel.set_units(_units)
	_panel.set_pool(_pool)
	_panel.reset_pending()

	# --- CAPTURE BASELINE AFTER INITIALIZATION + TESTS ---
	_capture_baseline()

	# Wire Reset to restore that baseline
	var reset_btn: Button = _panel.get_node_or_null("Root/Footer/ResetBtn") as Button
	if reset_btn:
		reset_btn.pressed.connect(_reset_to_baseline)

	# Listen for commits
	_panel.reinforcement_committed.connect(_on_committed)

	print("Startup pool:", _pool)  # should be 10

	# Optional demos (these mutate state later; baseline stays as captured)
	if AUTO_APPLY:
		var plan: Dictionary = {"ALPHA": 3, "BRAVO": 9, "CHARLIE": 5}
		_on_committed(plan)


# ---- Reinforcement flow ----


## Apply plan and keep Game + panel pools synchronized
func _on_committed(plan: Dictionary) -> void:
	var remaining: int = _pool
	for uid in plan.keys():
		var u: UnitData = _find(uid)
		if u == null:
			continue
		# Business rule: don't reinforce wiped-out
		if u.state_strength <= 0.0:
			continue

		var give: int = int(plan[uid])
		var cur: int = int(round(u.state_strength))
		var cap: int = int(max(0, u.strength))
		var missing: int = max(0, cap - cur)
		var applied: int = min(give, missing, remaining)
		if applied <= 0:
			continue
		u.state_strength = float(cur + applied)
		remaining -= applied

	# Persist remaining to Game (if present) and mirror to panel
	var g: Node = get_tree().get_root().get_node_or_null("/root/Game")
	if g:
		if g.has_method("set_replacement_pool"):
			g.set_replacement_pool(remaining)
		elif g.has_variable("campaign_replacement_pool"):
			g.campaign_replacement_pool = remaining

	_pool = remaining
	_panel.set_units(_units)  # refresh rows/badges/missing caps
	_panel.set_pool(_pool)
	_panel.reset_pending()

	print("Remaining pool:", _pool)
	for u: UnitData in _units:
		print(u.id, ": ", int(round(u.state_strength)), "/", int(u.strength))


# ---- Baseline snapshot & Reset ----


func _capture_baseline() -> void:
	_baseline_strengths.clear()
	for u: UnitData in _units:
		_baseline_strengths[u.id] = int(round(u.state_strength))
	_baseline_pool = _pool


## Restore baseline strengths and pool (test-only behavior for the Reset button)
func _reset_to_baseline() -> void:
	# Restore unit strengths
	for u: UnitData in _units:
		var base: int = int(_baseline_strengths.get(u.id, int(round(u.state_strength))))
		u.state_strength = float(base)

	# Restore pool (Game + panel)
	_pool = _baseline_pool
	var g: Node = get_tree().get_root().get_node_or_null("/root/Game")
	if g:
		if g.has_method("set_replacement_pool"):
			g.set_replacement_pool(_pool)
		elif g.has_variable("campaign_replacement_pool"):
			g.campaign_replacement_pool = _pool

	_panel.set_units(_units)
	_panel.set_pool(_pool)
	_panel.reset_pending()
	print("Reset to initial baseline — Pool:", _pool)


# ---- Optional test helpers (unchanged from your version) ----


## Make a tiny runtime PackedScene whose instance accepts a strength factor
func _make_unit_prefab() -> PackedScene:
	var holder: Node = Node.new()
	var gs: GDScript = GDScript.new()
	gs.source_code = """
extends Node
var strength_factor: float = 1.0
var base_count: int = 10
var count: int = 10
func apply_strength_factor(f: float) -> void:
	strength_factor = f
	if f <= 0.0:
		count = 0
	else:
		count = max(1, int(round(base_count * f)))
"""
	gs.reload()
	holder.set_script(gs)
	var ps: PackedScene = PackedScene.new()
	ps.pack(holder)
	return ps


## Build a mock scenario compatible with SimWorld.spawn_scenario_units()
func _make_mock_scenario() -> Node:
	var sc_script: GDScript = GDScript.new()
	sc_script.source_code = "extends Node\nvar units: Array = []\n"
	sc_script.reload()
	var scn: Node = Node.new()
	scn.set_script(sc_script)
	var list: Array = []
	for u: UnitData in _units:
		var su: Object = _make_mock_scenario_unit(u)
		list.append(su)
	scn.units = list
	return scn


## Make a mock "ScenarioUnit" object (extends Object) with .unit and .packed_scene
func _make_mock_scenario_unit(u: UnitData) -> Object:
	var sc: GDScript = GDScript.new()
	sc.source_code = "extends Object\nvar unit\nvar packed_scene\n"
	sc.reload()
	var inst: Object = sc.new()
	inst.unit = u
	inst.packed_scene = _make_unit_prefab()
	return inst


## Exercise SimWorld.spawn_scenario_units(): wiped-out filtered, factor forwarded
func _test_spawn() -> void:
	print("-- Spawn Test --")
	var sim: Node = Node.new()
	sim.name = "SimWorld"
	sim.set_script(load("res://scripts/sim/SimWorld.gd"))
	add_child(sim)
	await get_tree().process_frame
	var scenario: Node = _make_mock_scenario()
	sim.call("spawn_scenario_units", scenario)
	if sim.get_child_count() == 0:
		print("Spawn result: no children (likely only wiped-out units or spawn blocked)")
	else:
		for c in sim.get_children():
			var f: float = 0.0
			var raw_sf: Variant = null
			if c.has_method("get"):
				raw_sf = c.get("strength_factor")
			if typeof(raw_sf) == TYPE_FLOAT:
				f = raw_sf as float
			elif typeof(raw_sf) == TYPE_INT:
				f = float(raw_sf)
			var cnt: int = 0
			var raw_cnt: Variant = null
			if c.has_method("get"):
				raw_cnt = c.get("count")
			if typeof(raw_cnt) == TYPE_INT:
				cnt = raw_cnt as int
			elif typeof(raw_cnt) == TYPE_FLOAT:
				cnt = int(raw_cnt)
			prints("[spawned]", c.name, "factor=", f, "count=", cnt)


# ---------------------------
# Casualty hook test section
# ---------------------------


## Prove that apply_casualties_to_units mutates state_strength in place
func _test_casualties() -> void:
	print("-- Casualty Test --")
	# Use the real MissionResolution class (must have class_name MissionResolution)
	var res: MissionResolution = MissionResolution.new()

	# Sample losses: try to remove 3 from ALPHA, 2 from CHARLIE
	var losses: Dictionary = {
		"ALPHA": 3,
		"CHARLIE": 2,
		# BRAVO stays 0 unless reinforced first
	}
	res.apply_casualties_to_units(_units, losses)
	for u: UnitData in _units:
		prints("[after casualties]", u.id, int(round(u.state_strength)), "/", int(u.strength))
	_panel.set_units(_units)
	_panel.set_pool(_pool)


# ------------------------
# Demo data + utilities
# ------------------------


## Demo units (with per-unit threshold to validate badge/status)
func _make_demo_units() -> Array[UnitData]:
	var a: UnitData = UnitData.new()
	a.id = "ALPHA"
	a.title = "Alpha"
	a.strength = 30
	a.state_strength = 17.0
	a.understrength_threshold = 0.8

	var b: UnitData = UnitData.new()
	b.id = "BRAVO"
	b.title = "Bravo"
	b.strength = 30
	b.state_strength = 0.0  # wiped out
	b.understrength_threshold = 0.6

	var c: UnitData = UnitData.new()
	c.id = "CHARLIE"
	c.title = "Charlie"
	c.strength = 30
	c.state_strength = 27.0
	c.understrength_threshold = 0.9

	return [a, b, c]


## Lookup by id
func _find(uid: String) -> UnitData:
	for u: UnitData in _units:
		if u.id == uid:
			return u
	return null
