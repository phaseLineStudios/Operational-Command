class_name HQTable
extends Node3D
## Headquarter table bootstrapper for a mission.
##
## Sets up terrain, simulation world, radio pipeline, and speech word list.
## Generates playable units from scenario slots and binds controllers.

@onready var sim: SimWorld = %WorldController
@onready var map: MapController = %MapController
@onready var renderer: TerrainRender = %TerrainRender
@onready var debug_overlay: Control = %DebugOverlay
@onready var trigger_engine: TriggerEngine = %TriggerEngine
@onready var camera: Camera3D = %CameraController/CameraBounds/Camera
@onready var radio_subtitles: Control = %RadioSubtitles
@onready var radio: Radio = %RadioController
@onready var loading_screen: Control = %LoadingScreen
@onready var mission_dialog: Control = %MissionDialog
@onready var drawing_controller: DrawingController = %DrawingController
@onready var counter_controller: UnitCounterController = %UnitCounterController
@onready var document_controller: DocumentController = %DocumentController
@onready var unit_voices: UnitVoiceResponses = %UnitVoiceResponses
@onready var unit_auto_voices: UnitAutoResponses = %UnitAutoResponses
@onready var tts_player: AudioStreamPlayer = %TTSPlayer
@onready var ai_controller: AIController = %AIController


## Initialize mission systems and bind services.
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


## Initialize the drawing controller and bind to trigger API
func _init_drawing_controller() -> void:
	if drawing_controller:
		# Set the map mesh reference
		drawing_controller.map_mesh = %Map

	if trigger_engine and trigger_engine._api:
		trigger_engine._api.drawing_controller = drawing_controller


## Initialize the counter controller and bind to trigger API
func _init_counter_controller() -> void:
	# Initialize counter controller with map mesh and terrain render for coordinate conversion
	if counter_controller and map:
		counter_controller.init(%Map, map.renderer)

	if trigger_engine and trigger_engine._api:
		trigger_engine._api._counter_controller = counter_controller


## Initialize the document controller and render documents
func _init_document_controller(scenario: ScenarioData) -> void:
	if document_controller:
		await document_controller.init(%IntelDoc, %TranscriptDoc, %BriefingDoc, scenario)

		if sim:
			sim.radio_message.connect(_on_radio_transcript_ai)

		if unit_voices:
			unit_voices.unit_response.connect(_on_unit_voice_transcript)

		if unit_auto_voices:
			unit_auto_voices.unit_auto_response.connect(_on_unit_voice_transcript)


## Handle player radio result for transcript
func _on_radio_transcript_player_early(text: String) -> void:
	if document_controller and text != "":
		await document_controller.add_transcript_entry("PLAYER", text)


## Handle AI radio messages for transcript
func _on_radio_transcript_ai(level: String, text: String) -> void:
	if not document_controller or text == "":
		return

	if level == "debug":
		return

	await get_tree().process_frame

	var speaker := _extract_speaker_from_message(text)
	await document_controller.add_transcript_entry(speaker, text)


## Handle unit voice responses for transcript (both acknowledgments and auto-responses)
func _on_unit_voice_transcript(callsign: String, message: String) -> void:
	if document_controller and message != "":
		await document_controller.add_transcript_entry(callsign, message)


## Extract speaker callsign from message text if present, otherwise return "HQ".
## Handles formats: "ALPHA: message", "ALPHA message", or plain messages.
func _extract_speaker_from_message(text: String) -> String:
	# Check for "CALLSIGN: message" format
	var colon_pos := text.find(":")
	if colon_pos > 0:
		var potential_callsign := text.substr(0, colon_pos).strip_edges()
		# Verify it looks like a callsign (uppercase letters, possibly with numbers)
		if potential_callsign.length() >= 2 and potential_callsign.length() <= 12:
			if potential_callsign.to_upper() == potential_callsign:
				return potential_callsign

	# Check for "CALLSIGN message" format (first word is all caps)
	var words := text.split(" ", false, 1)
	if words.size() >= 2:
		var first_word := words[0].strip_edges()
		# Check if first word is uppercase and looks like a callsign
		if first_word.length() >= 2 and first_word.length() <= 12:
			if first_word.to_upper() == first_word and first_word.is_valid_identifier():
				return first_word

	# Default to HQ if no callsign detected
	return "HQ"


## Bind artillery and engineer controllers to trigger API for tracking
func _init_combat_controllers() -> void:
	if trigger_engine and trigger_engine._api and sim:
		if sim.artillery_controller:
			trigger_engine._api._bind_artillery_controller(sim.artillery_controller)

		if sim.engineer_controller:
			trigger_engine._api._bind_engineer_controller(sim.engineer_controller)


## Initialize TTS service and wire up unit voice responses
func _init_tts_system() -> void:
	if TTSService and tts_player:
		TTSService.register_player(tts_player)

	if unit_voices and sim and map:
		unit_voices.init(sim._units_by_id, sim, map.renderer)

	if unit_auto_voices and sim and map:
		unit_auto_voices.init(
			sim, sim._units_by_id, map.renderer, counter_controller, sim.artillery_controller
		)
		_wire_logistics_warnings()

	var orders_router := get_node_or_null("%RadioController/OrdersRouter")
	if orders_router and unit_voices:
		if not orders_router.order_applied.is_connected(unit_voices._on_order_applied):
			orders_router.order_applied.connect(unit_voices._on_order_applied)
		else:
			LogService.warning(
				"OrdersRouter already connected to UnitVoiceResponses!",
				"HQTable.gd:_init_tts_system"
			)

	if sim and TTSService:
		if not sim.radio_message.is_connected(_on_radio_message):
			sim.radio_message.connect(_on_radio_message)


## Wire up ammo/fuel warning signals to auto-response system.
func _wire_logistics_warnings() -> void:
	if not sim:
		return

	if sim.ammo_system:
		sim.ammo_system.ammo_low.connect(_on_ammo_low)
		sim.ammo_system.ammo_critical.connect(_on_ammo_critical)

	if sim.fuel_system:
		sim.fuel_system.fuel_low.connect(_on_fuel_low)
		sim.fuel_system.fuel_critical.connect(_on_fuel_critical)


## Handle ammo low warning.
func _on_ammo_low(unit_id: String) -> void:
	if unit_auto_voices:
		unit_auto_voices.trigger_ammo_low(unit_id)


## Handle ammo critical warning.
func _on_ammo_critical(unit_id: String) -> void:
	if unit_auto_voices:
		unit_auto_voices.trigger_ammo_critical(unit_id)


## Handle fuel low warning.
func _on_fuel_low(unit_id: String) -> void:
	if unit_auto_voices:
		unit_auto_voices.trigger_fuel_low(unit_id)


## Handle fuel critical warning.
func _on_fuel_critical(unit_id: String) -> void:
	if unit_auto_voices:
		unit_auto_voices.trigger_fuel_critical(unit_id)


## Handle radio messages from SimWorld (trigger API, ammo/fuel warnings, etc.)
func _on_radio_message(_level: String, text: String) -> void:
	# Skip "Order applied" and "Order failed" messages
	# These are already handled by UnitVoiceResponses
	if text.begins_with("Order applied") or text.begins_with("Order failed"):
		return

	# Skip ammo/fuel warnings - now handled by UnitAutoResponses
	if text.contains("low ammo") or text.contains("winchester") or text.contains("low on fuel"):
		return

	# Speak the message via TTS
	if TTSService and TTSService.is_ready():
		TTSService.say(text)


## Clean up when exiting (clears session drawings)
func _exit_tree() -> void:
	if drawing_controller:
		drawing_controller.clear_all()


## Build the list of playable units from scenario slots and current loadout.
## Assigns callsigns, positions, affiliation, and marks them as playable.
## [param slots] Array of UnitSlotData describing player-assignable slots.
## [return] Array[ScenarioUnit] created from the active loadout assignments.
func generate_playable_units(slots: Array[UnitSlotData]) -> Array[ScenarioUnit]:
	var units: Array[ScenarioUnit] = []
	var loadout := Game.current_scenario_loadout
	var assignments: Array = loadout.get("assignments", [])
	var callsigns := []
	for slot in slots:
		var key := slot.key

		var unit_data: UnitData
		for assignment in assignments:
			var slot_id: String = assignment.get("slot_id", "")
			if key == slot_id:
				var unit_id: String = assignment.get("unit_id", "")
				unit_data = ContentDB.get_unit(unit_id)

				var su := ScenarioUnit.new()
				su.id = unit_data.id + slot_id
				su.unit = unit_data
				su.affiliation = ScenarioUnit.Affiliation.FRIEND
				su.callsign = slot.callsign
				su.position_m = slot.start_position
				su.playable = true
				units.append(su)
				callsigns.append(slot.callsign)

	return units


## Handle radio PTT pressed
func _on_radio_on() -> void:
	radio_subtitles.show_partial("")


## Handle radio PTT released
func _on_radio_off() -> void:
	pass  # Wait for result to show final text


## Handle partial speech recognition
func _on_radio_partial(text: String) -> void:
	radio_subtitles.show_partial(text)


## Handle final speech recognition result
func _on_radio_result(text: String) -> void:
	radio_subtitles.show_result(text)


## Update subtitle suggestions with terrain labels and unit callsigns
func _update_subtitle_suggestions(scenario: ScenarioData) -> void:
	var labels: Array[String] = []
	if scenario.terrain and scenario.terrain.labels:
		for label_data in scenario.terrain.labels:
			var label_text := str(label_data.get("text", ""))
			if label_text != "":
				labels.append(label_text)

	var callsigns: Array[String] = []
	var all_units := []
	all_units.append_array(scenario.playable_units)
	all_units.append_array(scenario.units)

	for unit in all_units:
		if unit and unit.callsign != "":
			callsigns.append(unit.callsign)

	radio_subtitles.set_terrain_labels(labels)
	radio_subtitles.set_unit_callsigns(callsigns)


func _create_initial_unit_counters(playable_units: Array[ScenarioUnit]) -> void:
	for unit in playable_units:
		var counter := preload("res://scenes/system/unit_counter.tscn").instantiate()
		counter.affiliation = UnitCounter.CounterAffiliation.PLAYER
		counter.callsign = unit.callsign
		counter.symbol_type = unit.unit.type
		counter.symbol_size = unit.unit.size

		%PhysicsObjects.add_child(counter)

		# Convert unit terrain position to 3D world position
		var world_pos: Variant = _terrain_pos_to_world(unit.position_m)
		if world_pos != null:
			# Place counter slightly above the map surface
			counter.global_position = world_pos + Vector3(0, 0.05, 0)
		else:
			# Fallback to spawn location if conversion fails
			counter.global_position = %CounterSpawnLocation.global_position


## Convert terrain 2D position to 3D world position on the map.
## [param pos_m] Terrain position in meters (Vector2).
## [return] World position as Vector3, or null if conversion fails.
func _terrain_pos_to_world(pos_m: Vector2) -> Variant:
	if map == null or map.renderer == null:
		return null

	var map_mesh: MeshInstance3D = %Map
	if map_mesh == null or map_mesh.mesh == null:
		return null

	var mesh_size := Vector2.ZERO
	if map_mesh.mesh is PlaneMesh:
		mesh_size = map_mesh.mesh.size
	else:
		return null

	var terrain_data := map.renderer.data
	if terrain_data == null:
		return null

	var terrain_width_m := float(terrain_data.width_m)
	var terrain_height_m := float(terrain_data.height_m)

	if terrain_width_m == 0 or terrain_height_m == 0:
		return null

	# Normalize terrain position to -0.5..0.5 range (mesh local space)
	var t_pos_m := renderer.terrain_to_map(pos_m)
	var normalized_x := (t_pos_m.x / terrain_width_m) - 0.5
	var normalized_z := (t_pos_m.y / terrain_height_m) - 0.5

	# Scale to mesh size
	var local_pos := Vector3(normalized_x * mesh_size.x, 0, normalized_z * mesh_size.y)

	# Convert to world space
	var world_pos := map_mesh.to_global(local_pos)

	return world_pos


func _init_test_scenario() -> void:
	Game.current_campaign = ContentDB.get_campaign("nato_1985_west_ger")
	Game.current_scenario = ContentDB.get_scenario("us_crested_cap")
	Game.current_scenario_loadout = {
		"assignments":
		[
			{"slot_id": "SLOT_1", "slot_key": "SLOT_1", "unit_id": "scout_plt_1a111_acr"},
			{
				"slot_id": "SLOT_2",
				"slot_key": "SLOT_2",
				"unit_id": "us_11acr_a_trp_2plt_tank_m60a3"
			},
			{"slot_id": "SLOT_3", "slot_key": "SLOT_3", "unit_id": "us_11acr_a_trp_itv_sec"},
			{
				"slot_id": "SLOT_4",
				"slot_key": "SLOT_4",
				"unit_id": "us_11acr_a_trp_mortar_sec_m106"
			},
			{"slot_id": "SLOT_5", "slot_key": "SLOT_5", "unit_id": "us_11acr_field_trains_sec"},
			{"slot_id": "SLOT_6", "slot_key": "SLOT_6", "unit_id": "us_11acr_58engr_pl"}
		],
		"mission_id": "us_crested_cap",
		"points_used": 319
	}


func _init_enemy_ai() -> void:
	if ai_controller == null:
		push_error("_init_enemy_ai(): AIController node is missing from the scene.")
		return

	var scenario := Game.current_scenario
	if scenario == null:
		return

	if trigger_engine:
		ai_controller.bind_trigger_engine(trigger_engine)

	ai_controller.unregister_all_units()
	ai_controller.refresh_unit_index_cache()

	# Build per-unit queues from scenario JSON (normalize inside AIController)
	var flat_tasks: Array = []
	if scenario.tasks is Array:
		flat_tasks = scenario.tasks
	var normalized: Array = ai_controller.normalize_tasks(flat_tasks)
	var per_unit: Dictionary = ai_controller.build_per_unit_queues(normalized)
	ai_controller.apply_trigger_sync(per_unit, scenario.triggers)

	# Create an agent per ENEMY unit in scenario.units
	for i in scenario.units.size():
		var u: ScenarioUnit = scenario.units[i]
		if u == null or u.affiliation != ScenarioUnit.Affiliation.ENEMY:
			continue
		var agent := ai_controller.create_agent(i)
		if agent == null:
			continue

		# Apply ScenarioUnit initial behaviour/ROE before queue starts
		agent.set_behaviour(int(u.behaviour))
		agent.set_combat_mode(int(u.combat_mode))

		var ordered: Array = per_unit.get(i, [])
		if ordered.is_empty():
			agent.set_behaviour(ScenarioUnit.Behaviour.AWARE)
			u.behaviour = ScenarioUnit.Behaviour.AWARE
			agent.set_combat_mode(ScenarioUnit.CombatMode.DO_NOT_FIRE_UNLESS_FIRED_UPON)
			u.combat_mode = ScenarioUnit.CombatMode.DO_NOT_FIRE_UNLESS_FIRED_UPON
		ai_controller.register_unit(i, agent, ordered)
