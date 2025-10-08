class_name HQTable
extends Node3D

@export var debug: bool = false

@onready var sim: SimWorld = %WorldController
@onready var map: MapController = %MapController
@onready var debug_overlay: Control = %DebugOverlay


func _ready() -> void:
	var _playable_units := generate_playable_units(Game.current_scenario.unit_slots)
	Game.current_scenario.playable_units = _playable_units
	map.init_terrain(Game.current_scenario)
	sim.init_world(Game.current_scenario)
	sim.bind_radio(%RadioController, %OrdersParser)


## Build playable units array.
func generate_playable_units(slots: Array[UnitSlotData]) -> Array[ScenarioUnit]:
	var units: Array[ScenarioUnit] = []
	var loadout := Game.current_scenario_loadout
	var assignments: Array = loadout.get("assignments", [])
	var _callsigns := []
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
				units.append(su)
				_callsigns.append(slot.callsign)

	LogService.trace("Generated playable units: %s" % str(_callsigns), "HQTable.gd:42")
	return units
