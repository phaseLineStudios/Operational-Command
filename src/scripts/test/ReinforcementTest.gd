class_name ReinforcementTest
extends Node2D
## Minimal harness for the reinforcement flow using the proper scene instance.

const PANEL_SCENE: PackedScene = preload("res://scenes/ui/unit_mgmt/reinforcement_panel.tscn")

var _units: Array[UnitData] = []
var _panel: ReinforcementPanel

func _ready() -> void:
	_units = _make_demo_units()

	_panel = PANEL_SCENE.instantiate() as ReinforcementPanel
	add_child(_panel)

	_panel.set_units(_units)
	_panel.set_pool(10)
	_panel.reinforcement_committed.connect(_on_committed)

	var plan := {"ALPHA": 3, "BRAVO": 9, "CHARLIE": 5}
	_on_committed(plan)

func _on_committed(plan: Dictionary) -> void:
	var remaining := 10
	for uid in plan.keys():
		var u := _find(uid)
		if u == null: continue
		var give := int(plan[uid])
		var cur := int(round(u.state_strength))
		var cap := int(max(0, u.strength))
		var missing : float = max(0, cap - cur)
		var applied : float = min(give, missing, remaining)
		u.state_strength = float(cur + applied)
		remaining -= applied

	print("Remaining pool:", remaining)
	for u in _units:
		print(u.id, ": ", int(round(u.state_strength)), "/", int(u.strength))

func _make_demo_units() -> Array[UnitData]:
	var a := UnitData.new()
	a.id = "ALPHA"; a.title = "Alpha"; a.strength = 30; a.state_strength = 20.0
	var b := UnitData.new()
	b.id = "BRAVO"; b.title = "Bravo"; b.strength = 30; b.state_strength = 0.0
	var c := UnitData.new()
	c.id = "CHARLIE"; c.title = "Charlie"; c.strength = 30; c.state_strength = 28.0
	return [a, b, c]

func _find(uid: String) -> UnitData:
	for u in _units:
		if u.id == uid: return u
	return null
