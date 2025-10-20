class_name ReinforcementTest
extends Node2D
## Test harness that starts the pool at 10 and keeps it in sync with the panel + Game.
## Uses the exact preload path you requested and wires Reset to restore a baseline.

const PANEL_SCENE: PackedScene = preload("res://scenes/ui/unit_mgmt/reinforcement_panel.tscn")

const START_POOL := 10
const AUTO_APPLY := false  # set true to auto-apply the sample plan at startup

var _units: Array[UnitData] = []
var _panel: ReinforcementPanel
var _pool: int = START_POOL
var _baseline_strengths := {}  # { unit_id: int }

func _ready() -> void:
	# Demo units + capture baseline strengths
	_units = _make_demo_units()
	for u in _units:
		_baseline_strengths[u.id] = int(round(u.state_strength))

	# Seed Game's pool first (if autoload exists)
	var g := get_tree().get_root().get_node_or_null("/root/Game")
	if g:
		if g.has_method("set_replacement_pool"):
			g.set_replacement_pool(START_POOL)
		elif g.has_variable("campaign_replacement_pool"):
			g.campaign_replacement_pool = START_POOL

	# Instance the panel and wait one frame so onready nodes exist
	_panel = PANEL_SCENE.instantiate() as ReinforcementPanel
	add_child(_panel)
	await get_tree().process_frame

	# Hook Reset button to restore baseline (test-only convenience)
	var reset_btn := _panel.get_node_or_null("Root/Footer/ResetBtn") as Button
	if reset_btn:
		reset_btn.pressed.connect(_reset_to_baseline)

	# Read pool back from Game if present; otherwise use START_POOL
	if g:
		if g.has_method("get_replacement_pool"):
			_pool = int(g.get_replacement_pool())
		elif g.has_variable("campaign_replacement_pool"):
			_pool = int(g.campaign_replacement_pool)
	else:
		_pool = START_POOL

	# Configure panel and connect signals
	_panel.set_units(_units)
	_panel.set_pool(_pool)
	_panel.reinforcement_committed.connect(_on_committed)

	# OPTIONAL: prove flow by auto-applying a plan
	if AUTO_APPLY:
		var plan := { "ALPHA": 3, "BRAVO": 9, "CHARLIE": 5 }
		_on_committed(plan)

## Apply plan and keep Game + panel pools synchronized
func _on_committed(plan: Dictionary) -> void:
	var remaining: int = _pool
	for uid in plan.keys():
		var u := _find(uid)
		if u == null:
			continue
		# Business rule (mirrors UnitMgmt): don't reinforce wiped-out units
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
	var g := get_tree().get_root().get_node_or_null("/root/Game")
	if g:
		if g.has_method("set_replacement_pool"):
			g.set_replacement_pool(remaining)
		elif g.has_variable("campaign_replacement_pool"):
			g.campaign_replacement_pool = remaining

	_pool = remaining
	_panel.set_units(_units)   # refresh rows/badges/missing caps
	_panel.set_pool(_pool)
	_panel.reset_pending()

	print("Remaining pool:", _pool)
	for u in _units:
		print(u.id, ": ", int(round(u.state_strength)), "/", int(u.strength))

## Restore baseline strengths and pool (test-only behavior for the Reset button)
func _reset_to_baseline() -> void:
	for u in _units:
		var base := int(_baseline_strengths.get(u.id, int(round(u.state_strength))))
		u.state_strength = float(base)

	_pool = START_POOL

	# Keep Game in sync if present
	var g := get_tree().get_root().get_node_or_null("/root/Game")
	if g:
		if g.has_method("set_replacement_pool"):
			g.set_replacement_pool(_pool)
		elif g.has_variable("campaign_replacement_pool"):
			g.campaign_replacement_pool = _pool

	_panel.set_units(_units)
	_panel.set_pool(_pool)
	_panel.reset_pending()

	print("Reset to baseline — Pool:", _pool)

## Demo units
func _make_demo_units() -> Array[UnitData]:
	var a := UnitData.new()
	a.id = "ALPHA"; a.title = "Alpha"; a.strength = 30; a.state_strength = 20.0

	var b := UnitData.new()
	b.id = "BRAVO"; b.title = "Bravo"; b.strength = 30; b.state_strength = 0.0   # wiped out

	var c := UnitData.new()
	c.id = "CHARLIE"; c.title = "Charlie"; c.strength = 30; c.state_strength = 28.0

	return [a, b, c]

## Lookup by id
func _find(uid: String) -> UnitData:
	for u in _units:
		if u.id == uid:
			return u
	return null
