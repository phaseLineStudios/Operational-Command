# CombatTest::_ready Function Reference

*Defined at:* `scripts/test/CombatTest.gd` (lines 26–71)</br>
*Belongs to:* [CombatTest](../../CombatTest.md)

**Signature**

```gdscript
func _ready() -> void
```

## Source

```gdscript
func _ready() -> void:
	# add the fuel system
	add_child(fuel)
	if renderer == null or renderer.data == null:
		push_warning("Setup: TerrainRender or TerrainData missing.")
		return
	if renderer.path_grid == null:
		push_warning("Setup: Assign PathGrid to TerrainRender.path_grid.")
		return

	var s := _load_scenario_json(scenario_data_json)
	_scenario = ScenarioData.deserialize(s)
	if _scenario == null or _scenario.units.is_empty():
		push_warning("Setup: Scenario invalid or has no units.")
		return

	_su_a = _find_su(_scenario.units, unit_a_id)
	_su_b = _find_su(_scenario.units, unit_b_id)
	if _su_a == null or _su_b == null:
		push_warning("Setup: Could not find both units in scenario.")
		return

	# register the fuel for the units
	fuel.register_scenario_unit(_su_a)
	_su_a.bind_fuel_system(fuel)
	fuel.register_scenario_unit(_su_b)
	_su_b.bind_fuel_system(fuel)

	renderer.path_grid.rebuild(TerrainBrush.MoveProfile.FOOT)
	renderer.path_grid.build_ready.connect(func(_p): print("PathGrid ready."))
	renderer.path_grid.build_failed.connect(
		func(reason): push_warning("PathGrid build failed: " + reason)
	)

	if input_overlay and input_overlay.has_method("setup_overlay"):
		input_overlay.call_deferred("setup_overlay", renderer, [_su_a, _su_b])

	if combat:
		combat.scenario = _scenario
		combat.terrain_renderer = renderer
		combat.debug_overlay = input_overlay
		combat.combat_loop(_su_a, _su_b)

	input_overlay.gui_input.connect(_input)
```
