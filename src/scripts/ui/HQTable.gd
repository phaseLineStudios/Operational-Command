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


## Initialize mission systems and bind services.
func _ready() -> void:
	var scenario = Game.current_scenario
	var playable_units := generate_playable_units(scenario.unit_slots)
	scenario.playable_units = playable_units
	map.init_terrain(scenario)
	sim.init_world(scenario)
	trigger_engine.bind_scenario(scenario)
	sim.bind_radio(%RadioController, %OrdersParser)
	sim.init_resolution(scenario.briefing.frag_objectives)


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
