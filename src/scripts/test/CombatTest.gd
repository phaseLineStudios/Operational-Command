class_name CombatTest
extends Node2D
## Minimal combat/movement + combat debug harness.

## Scenario JSON file
@export_file("*.json ; Scenario")
var scenario_data_json: String = "res://scripts/test/combat_test_scenario.json"

## IDs of the two placed units in ScenarioData.content.units
@export var unit_a_id := "infantry_plt_1_1"
@export var unit_b_id := "infantry_plt_2_1"

var _scenario: ScenarioData
var _su_a: ScenarioUnit
var _su_b: ScenarioUnit

## Using FuelSystem
@onready var fuel: FuelSystem = FuelSystem.new()

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
	fuel.register_scenario_unit(_su_a); _su_a.bind_fuel_system(fuel)
	fuel.register_scenario_unit(_su_b); _su_b.bind_fuel_system(fuel)

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


func _process(dt: float) -> void:
	if renderer and renderer.path_grid:
		if _su_a:
			_su_a.tick(dt, renderer.path_grid)
		if _su_b:
			_su_b.tick(dt, renderer.path_grid)
	if input_overlay:
		input_overlay.queue_redraw()
	fuel.tick(dt)

func _input(e: InputEvent) -> void:
	if not (e is InputEventMouseButton and e.pressed):
		return
	if renderer == null or _scenario == null:
		return
	var me := e as InputEventMouseButton
	var pos := me.position
	if not renderer.is_inside_terrain(pos):
		print("Outside terrain:", pos)
		return
	var terrain_pos := renderer.map_to_terrain(pos)

	if me.button_index == MOUSE_BUTTON_LEFT:
		_move_su_to(_su_a, terrain_pos)
	elif me.button_index == MOUSE_BUTTON_RIGHT:
		_move_su_to(_su_b, terrain_pos)


func _move_su_to(su: ScenarioUnit, dest_m: Vector2) -> void:
	if su == null or renderer.path_grid == null:
		return
	if su.plan_move(renderer.path_grid, dest_m):
		su.start_move(renderer.path_grid)
		print("%s -> %s (%s)" % [su.callsign, str(dest_m), renderer.pos_to_grid(dest_m)])


func _load_scenario_json(path: String) -> Dictionary:
	if path == "" or not FileAccess.file_exists(path):
		push_warning("Scenario JSON not found: " + path)
		return {}
	var txt := FileAccess.get_file_as_string(path)
	var parsed: Variant = JSON.parse_string(txt)
	return parsed if typeof(parsed) == TYPE_DICTIONARY else {}


func _find_su(list: Array[ScenarioUnit], key: String) -> ScenarioUnit:
	for su in list:
		if su == null:
			continue
		if su.id == key:
			return su
		if su.unit and su.unit.id == key:
			return su
	return null
