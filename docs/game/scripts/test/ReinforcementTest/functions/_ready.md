# ReinforcementTest::_ready Function Reference

*Defined at:* `scripts/test/ReinforcementTest.gd` (lines 26–87)</br>
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
```
