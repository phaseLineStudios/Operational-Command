class_name ReinforcementTest
extends Node2D
## Test harness that starts the pool at 10 and keeps it in sync with the panel + Game.
## Uses your exact preload path and does NOT spend the pool automatically.

const PANEL_SCENE: PackedScene = preload("res://scenes/ui/unit_mgmt/reinforcement_panel.tscn")

const START_POOL := 10
const AUTO_APPLY := false  # set to true if you want to auto-apply the sample plan at startup

var _units: Array[UnitData] = []
var _panel: ReinforcementPanel
var _pool: int = START_POOL

func _ready() -> void:
	# Create demo units
	_units = _make_demo_units()

	# Seed Game's pool first (if autoload exists)
	var g := get_tree().get_root().get_node_or_null("/root/Game")
	if g:
		if g.has_method("set_replacement_pool"):
			g.set_replacement_pool(START_POOL)
		elif g.has_variable("campaign_replacement_pool"):
			g.campaign_replacement_pool = START_POOL

	# Instance the panel and wait one frame so its onready nodes exist
	_panel = PANEL_SCENE.instantiate() as ReinforcementPanel
	add_child(_panel)
	await get_tree().process_frame

	# Configure panel with units and starting pool (read back from Game if present)
	if g:
		if g.has_method("get_replacement_pool"):
			_pool = int(g.get_replacement_pool())
		elif g.has_variable("campaign_replacement_pool"):
			_pool = int(g.campaign_replacement_pool)
	else:
		_pool = START_POOL

	_panel.set_units(_units)
	_panel.set_pool(_pool)
	_panel.reinforcement_committed.connect(_on_committed)

	print("Startup pool:", _pool)  # should be 10

	# OPTIONAL: auto-apply a sample plan to prove flow
	# only activate if needed, automatically consumes the resource pool
	if AUTO_APPLY:
		var plan := { "ALPHA": 3, "BRAVO": 9, "CHARLIE": 5 }
		_on_committed(plan)

## Apply plan and keep Game + panel pools synchronized
func _on_committed(plan: Dictionary) -> void:
	var remaining: int = _pool
	for uid in plan.keys():
		var u := _find(uid)
		if u == null: continue
		var give: int = int(plan[uid])
		var cur: int = int(round(u.state_strength))
		var cap: int = int(max(0, u.strength))
		var missing: int = max(0, cap - cur)
		var applied: int = min(give, missing, remaining)
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
	_panel.set_pool(_pool)
	_panel.reset_pending()  # clear any preview amounts

	print("Remaining pool:", _pool)
	for u in _units:
		print(u.id, ": ", int(round(u.state_strength)), "/", int(u.strength))

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
		if u.id == uid: return u
	return null
