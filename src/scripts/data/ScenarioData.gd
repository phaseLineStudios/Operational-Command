extends Resource
class_name ScenarioData

## Enumeration of scenario difficulty levels
enum scenarioDifficulty { easy, normal, hard }

## Unique identifier for this scenario
@export var id: String
## Human-readable title of the scenario
@export var title: String
## Short Scenario description shown to the player
@export var description: String
## File path to the scenario preview image
@export_file("*.png *.jpg ; Image") var preview_path: String
## The scenario terrain data
@export var terrain: TerrainData
## The scenario briefing data
@export var briefing: BriefData

@export_category("Meta")
## Difficulty of the scenario
@export var difficulty: scenarioDifficulty
## Position of the scenario on the campaign/selection map
@export var map_position: Vector2
## Order index of the scenario in a campaign sequence
@export var scenario_order: int = 0

@export_category("Weather")
## Rainfall in millimeters per hour
@export_range(0.0, 50.0, 0.05) var rain: float = 0.0
## Fog visibility in meters
@export_range(0.0, 10000.0, 1.0) var fog_m: float = 8000.0
## Wind direction in degrees
@export_range(0.0, 360.0, 1.0) var wind_dir: float = 0.0
## Wind speed in meters per second
@export_range(0.0, 110.0, 0.5) var wind_speed_m: float = 1.0

@export_category("datetime")
## Year when the scenario takes place
@export var year: int = 1983
## Month when the scenario takes place
@export_range(1.0, 12.0, 1.0) var month: int = 1
## Day of the month
@export_range(1.0, 31.0, 1.0) var day: int = 1
## Hour of the day
@export_range(0.0, 23.0, 1.0) var hour: int = 12
## Minute of the hour
@export_range(0.0, 59.0, 1.0) var minute: int = 0

@export_category("Units")
## Total points available to the player to deploy units
@export var unit_points: int = 500
## Slots available for units to be placed into
@export var unit_slots: Array[UnitSlotData]
## Recruitable units available at the start
@export var unit_recruits: Array[UnitData] = []
## Reserve slots for reinforcements or delayed units
@export var unit_reserves: Array[UnitSlotData]
## Friendly Callsign List
@export var friendly_callsigns: Array[String]
## Enemy Callsign List
@export var enemy_callsigns: Array[String]

@export_group("Content")
## List of units placed in this scenario
@export var units: Array[ScenarioUnit] = []
## Triggers that define scripted events and conditions
@export var triggers: Array[ScenarioTrigger] = []
## Tasks or objectives for the AI to complete
@export var tasks: Array[ScenarioTask] = []
## Drawings or map overlays associated with the scenario
@export var drawings: Array = []

var preview: Texture2D

## Serialize data to JSON
func serialize() -> Dictionary:
	var recruit_ids: Array = []
	for u in unit_recruits:
		if u is UnitData and u.id != null and String(u.id) != "":
			recruit_ids.append(String(u.id))

	var placed_units: Array = []
	for unit in units:
		if unit is ScenarioUnit:
			placed_units.append(unit.serialize())
			
	var placed_triggers: Array = []
	for trigger in triggers:
		if trigger is ScenarioTrigger:
			placed_triggers.append(trigger.serialize())
			
	var placed_tasks: Array = []
	for task in tasks:
		if task is ScenarioTask:
			placed_tasks.append(task.serialize())

	return {
		"id": id,
		"title": title,
		"description": description,
		"preview_path": preview_path,
		"terrain_path": (ContentDB.res_path_or_null(terrain)),
		"briefing_id": (briefing.id as Variant if briefing else null as Variant),
		"difficulty": int(difficulty),
		"map_position": _vec2_to_dict(map_position),
		"scenario_order": scenario_order,

		"weather": {
			"rain": rain,
			"fog_m": fog_m,
			"wind_dir": wind_dir,
			"wind_speed_m": wind_speed_m
		},

		"datetime": {
			"year": year, "month": month, "day": day, "hour": hour, "minute": minute
		},

		"units": {
			"unit_points": unit_points,
			"unit_slots": _serialize_unit_slots(unit_slots),
			"unit_recruits_ids": recruit_ids,
			"unit_reserves": _serialize_unit_slots(unit_reserves)
		},

		"content": {
			"units": placed_units,
			"triggers": placed_triggers,
			"tasks": placed_tasks,
			"drawings": drawings
		}
	}

## Deserialize data from JSON
static func deserialize(json: Variant) -> ScenarioData:
	if typeof(json) != TYPE_DICTIONARY:
		return null

	var s := ScenarioData.new()
	s.id = json.get("id", s.id)
	s.title = json.get("title", s.title)
	s.description = json.get("description", s.description)
	s.preview_path = json.get("preview_path", s.preview_path)
	
	var terr_path: Variant = json.get("terrain_path", null)
	if typeof(terr_path) == TYPE_STRING and terr_path != "":
		var terr: Variant = ContentDB.load_res(String(terr_path))
		if terr is TerrainData:
			s.terrain = terr

	var brief_id := str(json.get("briefing_id", ""))
	if brief_id != "":
		var brief: BriefData = ContentDB.get_briefing(brief_id)
		if brief is BriefData:
			s.briefing = brief

	@warning_ignore("int_as_enum_without_cast")
	s.difficulty = _difficulty_from(json.get("difficulty", s.difficulty))
	s.map_position = _dict_to_vec2(json.get("map_position", _vec2_to_dict(s.map_position)))
	s.scenario_order = int(json.get("scenario_order", s.scenario_order))

	var weather: Dictionary = json.get("weather", {})
	if typeof(weather) == TYPE_DICTIONARY:
		s.rain = float(weather.get("rain", s.rain))
		s.fog_m = float(weather.get("fog_m", s.fog_m))
		s.wind_dir = float(weather.get("wind_dir", s.wind_dir))
		s.wind_speed_m = float(weather.get("wind_speed_m", s.wind_speed_m))

	var dt: Dictionary = json.get("datetime", {})
	if typeof(dt) == TYPE_DICTIONARY:
		s.year = int(dt.get("year", s.year))
		s.month = int(dt.get("month", s.month))
		s.day = int(dt.get("day", s.day))
		s.hour = int(dt.get("hour", s.hour))
		s.minute = int(dt.get("minute", s.minute))

	var um: Dictionary = json.get("units", {})
	if typeof(um) == TYPE_DICTIONARY:
		s.unit_points = int(um.get("unit_points", s.unit_points))
		s.unit_slots = _deserialize_unit_slots(um.get("unit_slots", []))
		s.unit_reserves = _deserialize_unit_slots(um.get("unit_reserves", []))

		var recruit_ids: Array = um.get("unit_recruits_ids", [])
		if typeof(recruit_ids) == TYPE_ARRAY:
			s.unit_recruits = ContentDB.get_units(recruit_ids)

	var content: Dictionary = json.get("content", {})
	if typeof(content) == TYPE_DICTIONARY:
		var placed_units: Array = content.get("units", [])
		if typeof(placed_units) == TYPE_ARRAY:
			var scenario_units: Array[ScenarioUnit] = []
			for unit in placed_units:
				scenario_units.append(ScenarioUnit.deserialize(unit))
			s.units = scenario_units
			
		var placed_triggers: Array = content.get("triggers", [])
		if typeof(placed_triggers) == TYPE_ARRAY:
			var scenario_triggers: Array[ScenarioTrigger] = []
			for trig in placed_triggers:
				scenario_triggers.append(ScenarioTrigger.deserialize(trig))
			s.triggers = scenario_triggers
			
		var placed_tasks: Array = content.get("tasks", [])
		if typeof(placed_tasks) == TYPE_ARRAY:
			var scenario_tasks: Array[ScenarioTask] = []
			for task in placed_tasks:
				scenario_tasks.append(ScenarioTask.deserialize(task))
			s.tasks = scenario_tasks

		s.drawings = content.get("drawings", s.drawings)

	if typeof(s.preview_path) == TYPE_STRING and s.preview_path != "":
		var tex := load(s.preview_path)
		if tex is Texture2D:
			s.preview = tex

	return s

static func _vec2_to_dict(v: Vector2) -> Dictionary:
	return {"x": v.x, "y": v.y}

static func _dict_to_vec2(d: Variant) -> Vector2:
	if typeof(d) == TYPE_DICTIONARY and d.has("x") and d.has("y"):
		return Vector2(float(d["x"]), float(d["y"]))
	if typeof(d) == TYPE_ARRAY and d.size() >= 2:
		return Vector2(float(d[0]), float(d[1]))
	return Vector2.ZERO

func _serialize_unit_slots(arr: Array) -> Array:
	var out: Array = []
	for item in arr:
		if item == null:
			out.append(null)
			continue

		out.append(item.serialize())
	return out

static func _deserialize_unit_slots(payload: Variant) -> Array[UnitSlotData]:
	var out: Array[UnitSlotData] = []
	if typeof(payload) != TYPE_ARRAY:
		return out
	for it in payload:
		var slot: UnitSlotData = null
		if it is UnitSlotData:
			slot = it
		elif typeof(it) == TYPE_DICTIONARY:
			slot = UnitSlotData.deserialize(it)
		if slot != null:
			out.append(slot)
	return out

static func _difficulty_from(json_value: Variant) -> int:
	if typeof(json_value) == TYPE_INT:
		return clamp(int(json_value), 0, 2)
	if typeof(json_value) == TYPE_STRING:
		match String(json_value).to_lower():
			"easy": return scenarioDifficulty.easy
			"normal": return scenarioDifficulty.normal
			"hard": return scenarioDifficulty.hard
	return scenarioDifficulty.normal
