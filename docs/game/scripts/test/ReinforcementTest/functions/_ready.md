# ReinforcementTest::_ready Function Reference

*Defined at:* `scripts/test/ReinforcementTest.gd` (lines 28–92)</br>
*Belongs to:* [ReinforcementTest](../../ReinforcementTest.md)

**Signature**

```gdscript
func _ready() -> void
```

## Source

```gdscript
func _ready() -> void:
	# Demo units
	_units = _make_demo_units()
	# Initialize strength dictionary from demo units (see _make_demo_units for values)
	for u in _units:
		# Values set in _make_demo_units: ALPHA=17, BRAVO=0 (wiped), CHARLIE=27
		_unit_strength[u.id] = float(u.strength)  # Will be overridden below

	# Set test values explicitly
	_unit_strength["ALPHA"] = 17.0
	_unit_strength["BRAVO"] = 0.0  # wiped out
	_unit_strength["CHARLIE"] = 27.0

	# Seed Game's scenario pool first (if autoload exists and scenario is loaded)
	var g: Node = get_tree().get_root().get_node_or_null("/root/Game")
	if g and g.current_scenario:
		g.current_scenario.replacement_pool = START_POOL

	# Build panel and wait a frame so onready nodes exist
	_panel = PANEL_SCENE.instantiate() as ReinforcementPanel
	add_child(_panel)
	await get_tree().process_frame

	# Initial pool (prefer Game scenario's value)
	if g and g.current_scenario:
		_pool = int(g.current_scenario.replacement_pool)
	else:
		_pool = START_POOL

	# Configure panel (initial view)
	_panel.set_units(_units, _unit_strength)
	_panel.set_pool(_pool)
	_panel.reset_pending()

	# ---- run optional tests BEFORE capturing the baseline ----
	if RUN_SPAWN_TEST:
		_test_spawn()

	if RUN_CASUALTY_TEST:
		_test_casualties()

	# Ensure panel reflects any mutations from tests, then snapshot
	_panel.set_units(_units, _unit_strength)
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
```
