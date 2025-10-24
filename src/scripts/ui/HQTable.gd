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
@onready var debug_overlay: Control = %DebugOverlay
@onready var trigger_engine: TriggerEngine = %TriggerEngine
@onready var camera: Camera3D = %CameraController/CameraBounds/Camera
@onready var radio_subtitles: Control = %RadioSubtitles
@onready var radio: Radio = %RadioController
@onready var loading_screen: Control = %LoadingScreen
@onready var mission_dialog: Control = %MissionDialog


## Initialize mission systems and bind services.
func _ready() -> void:
	# Show loading screen and wait one frame for it to render
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

	# Connect radio signals to subtitle display
	radio.radio_on.connect(_on_radio_on)
	radio.radio_off.connect(_on_radio_off)
	radio.radio_partial.connect(_on_radio_partial)
	radio.radio_result.connect(_on_radio_result)

	# Pass terrain labels and unit callsigns to subtitle system
	_update_subtitle_suggestions(scenario)

	# All initialization complete - hide loading screen
	loading_screen.hide_loading()


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
	# Extract terrain labels
	var labels: Array[String] = []
	if scenario.terrain and scenario.terrain.labels:
		for label_data in scenario.terrain.labels:
			var label_text := str(label_data.get("text", ""))
			if label_text != "":
				labels.append(label_text)

	# Extract all unit callsigns (playable, AI, and enemy)
	var callsigns: Array[String] = []
	var all_units := []
	all_units.append_array(scenario.playable_units)
	all_units.append_array(scenario.units)

	for unit in all_units:
		if unit and unit.callsign != "":
			callsigns.append(unit.callsign)

	# Pass to subtitle system
	radio_subtitles.set_terrain_labels(labels)
	radio_subtitles.set_unit_callsigns(callsigns)
