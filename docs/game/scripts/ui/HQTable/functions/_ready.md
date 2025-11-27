# HQTable::_ready Function Reference

*Defined at:* `scripts/ui/HQTable.gd` (lines 28–76)</br>
*Belongs to:* [HQTable](../../HQTable.md)

**Signature**

```gdscript
func _ready() -> void
```

## Description

Initialize mission systems and bind services.

## Source

```gdscript
func _ready() -> void:
	if Game.current_scenario == null:
		_init_test_scenario()

	loading_screen.show_loading(Game.current_scenario, "Initializing mission...")
	await get_tree().process_frame

	var scenario = Game.current_scenario
	var playable_units := generate_playable_units(scenario.unit_slots)
	scenario.playable_units = playable_units

	map.init_terrain(scenario)
	trigger_engine.bind_scenario(scenario)
	trigger_engine.bind_dialog(mission_dialog)
	if trigger_engine and trigger_engine._api:
		trigger_engine._api.map_controller = map
	sim.init_world(scenario)

	if radio and document_controller:
		radio.radio_result.connect(_on_radio_transcript_player_early)

	sim.bind_radio(%RadioController, %OrdersParser)
	sim.init_resolution(scenario.briefing.frag_objectives)

	_init_drawing_controller()

	if drawing_controller and map:
		drawing_controller.load_scenario_drawings(scenario, renderer)

	_init_counter_controller()
	_init_document_controller(scenario)
	_init_combat_controllers()
	_init_tts_system()

	radio.radio_on.connect(_on_radio_on)
	radio.radio_off.connect(_on_radio_off)
	radio.radio_partial.connect(_on_radio_partial)
	radio.radio_result.connect(_on_radio_result)

	_update_subtitle_suggestions(scenario)
	_create_initial_unit_counters(playable_units)

	# Initialize the AI
	_init_enemy_ai()

	# All initialization complete - hide loading screen
	loading_screen.hide_loading()
```
