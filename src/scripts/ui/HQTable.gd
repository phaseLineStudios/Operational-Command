class_name HQTable
extends Node3D
## Headquarter table bootstrapper for a mission.
##
## Sets up terrain, simulation world, radio pipeline, and speech word list.
## Generates playable units from scenario slots and binds controllers.

## Enable extra debug paths/overlays in connected systems.
@export var debug: bool = false

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
@onready var unit_voices: UnitVoiceResponses = %UnitVoiceResponses
@onready var unit_auto_voices: UnitAutoResponses = %UnitAutoResponses
@onready var tts_player: AudioStreamPlayer = %TTSPlayer


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
	sim.init_world(scenario)
	sim.bind_radio(%RadioController, %OrdersParser)
	sim.init_resolution(scenario.briefing.frag_objectives)

	# Initialize drawing controller
	_init_drawing_controller()

	# Load scenario drawings
	if drawing_controller and map:
		drawing_controller.load_scenario_drawings(scenario, renderer)

	# Initialize counter controller
	_init_counter_controller()

	# Initialize TTS and unit voice responses
	_init_tts_system()

	# Connect radio signals to subtitle display
	radio.radio_on.connect(_on_radio_on)
	radio.radio_off.connect(_on_radio_off)
	radio.radio_partial.connect(_on_radio_partial)
	radio.radio_result.connect(_on_radio_result)

	_update_subtitle_suggestions(scenario)
	_create_initial_unit_counters(playable_units)

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


## Initialize TTS service and wire up unit voice responses
func _init_tts_system() -> void:
	# Register the audio player with TTSService
	if TTSService and tts_player:
		TTSService.register_player(tts_player)
		LogService.trace("TTS player registered in HQTable.", "HQTable.gd:_init_tts_system")

	# Initialize UnitVoiceResponses with unit index, SimWorld, and terrain renderer
	if unit_voices and sim and map:
		unit_voices.init(sim._units_by_id, sim, map.renderer)
		LogService.trace("Unit voice responses initialized.", "HQTable.gd:_init_tts_system")

	# Initialize UnitAutoResponses for automatic unit event reporting
	if unit_auto_voices and sim and map:
		unit_auto_voices.init(
			sim, sim._units_by_id, map.renderer, counter_controller, sim.artillery_controller
		)
		LogService.trace("Unit auto responses initialized.", "HQTable.gd:_init_tts_system")

		# Wire up ammo/fuel warnings to auto-response system
		_wire_logistics_warnings()

	# Wire up OrdersRouter to UnitVoiceResponses
	var orders_router := get_node_or_null("%RadioController/OrdersRouter")
	if orders_router and unit_voices:
		# Check if already connected to avoid duplicate connections
		if not orders_router.order_applied.is_connected(unit_voices._on_order_applied):
			orders_router.order_applied.connect(unit_voices._on_order_applied)
			LogService.trace(
				"Unit voice responses connected to OrdersRouter.", "HQTable.gd:_init_tts_system"
			)
		else:
			LogService.warning(
				"OrdersRouter already connected to UnitVoiceResponses!",
				"HQTable.gd:_init_tts_system"
			)

	# Wire up SimWorld radio_message signal to TTS for trigger API radio() calls
	if sim and TTSService:
		if not sim.radio_message.is_connected(_on_radio_message):
			sim.radio_message.connect(_on_radio_message)
			LogService.trace(
				"SimWorld radio_message connected to TTS.", "HQTable.gd:_init_tts_system"
			)


## Wire up ammo/fuel warning signals to auto-response system.
func _wire_logistics_warnings() -> void:
	if not sim:
		return

	# Connect ammo system warnings
	if sim.ammo_system:
		sim.ammo_system.ammo_low.connect(_on_ammo_low)
		sim.ammo_system.ammo_critical.connect(_on_ammo_critical)

	# Connect fuel system warnings
	if sim.fuel_system:
		sim.fuel_system.fuel_low.connect(_on_fuel_low)
		sim.fuel_system.fuel_critical.connect(_on_fuel_critical)

	LogService.trace("Logistics warnings wired to auto-response system.", "HQTable.gd")


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

	LogService.trace("Generated playable units: %s" % str(callsigns), "HQTable.gd:42")
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
	var z_shift := 0.0
	for unit in playable_units:
		var counter := preload("res://scenes/system/unit_counter.tscn").instantiate()
		counter.affiliation = UnitCounter.CounterAffiliation.PLAYER
		counter.callsign = unit.callsign
		counter.symbol_type = unit.unit.type
		counter.symbol_size = unit.unit.size

		%PhysicsObjects.add_child(counter)

		var world_pos: Vector3 = %CounterSpawnLocation.global_position + Vector3(0, 0, z_shift)
		counter.global_position = world_pos
		z_shift += 0.05


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
