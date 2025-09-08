extends Resource
class_name ScenarioData

enum scenarioDifficulty { easy, normal, hard }

@export var id: String
@export var title: String
@export var description: String
@export_file("*.png *.jpg ; Image") var preview_path: String
@export_file("*.tres *.res ; TerrainData") var terrain_path: String

@export_category("Meta")
@export var difficulty: scenarioDifficulty
@export var map_position: Vector2
@export var scenario_order: int = 0

@export_category("Weather")
## Rainfall in mm per hour
@export_range(0.0, 50.0, 0.05) var rain: float = 0.0
## Fog Visibility in meters
@export_range(0.0, 10000.0, 1.0) var fog_m: float = 8000.0
@export_range(0.0, 360.0, 1.0) var wind_dir: float = 0.0
@export_range(0.0, 110.0, 0.5) var wind_speed_m: float = 1.0

@export_category("datetime")
@export var year: int = 1983
@export_range(1.0, 12.0, 1.0) var month: int = 1
@export_range(1.0, 31.0, 1.0) var day: int = 1
@export_range(0.0, 23.0, 1.0) var hour: int = 12
@export_range(0.0, 59.0, 1.0) var minute: int = 0

@export_category("Units")
@export var unit_points: int = 500
@export var unit_slots: Array[UnitSlotData]
@export var unit_recruits: Array = []
@export var unit_reserves: Array[UnitSlotData]

@export_group("Content")
@export var units: Array = []
@export var triggers: Array = []
@export var tasks: Array = []
@export var drawings: Array = []

var preview: Texture2D
var terrain: TerrainData

## Serialize data to JSON
func serialize() -> Dictionary:
	return {
		"id": id,
		"title": title,
		"description": description,
		"preview_path": preview_path,
		"terrain_path": terrain_path,

		"meta": {
			"difficulty": int(difficulty),
			"map_position": _vec2_to_dict(map_position),
			"scenario_order": scenario_order
		},

		"weather": {
			"rain": rain,
			"fog_m": fog_m,
			"wind_dir": wind_dir,
			"wind_speed_m": wind_speed_m
		},

		"datetime": {
			"year": year,
			"month": month,
			"day": day,
			"hour": hour,
			"minute": minute
		},

		"units_meta": {
			"unit_points": unit_points,
			"unit_slots": _serialize_unit_slots(unit_slots),
			"unit_recruits": unit_recruits,
			"unit_reserves": _serialize_unit_slots(unit_reserves)
		},

		"content": {
			"units": units,
			"triggers": triggers,
			"tasks": tasks,
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
	s.terrain_path = json.get("terrain_path", s.terrain_path)

	var meta: Dictionary = json.get("meta", {})
	if typeof(meta) == TYPE_DICTIONARY:
		@warning_ignore("int_as_enum_without_cast")
		s.difficulty = _difficulty_from(meta.get("difficulty", s.difficulty))
		s.map_position = _dict_to_vec2(meta.get("map_position", _vec2_to_dict(s.map_position)))
		s.scenario_order = int(meta.get("scenario_order", s.scenario_order))

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

	var um: Dictionary = json.get("units_meta", {})
	if typeof(um) == TYPE_DICTIONARY:
		s.unit_points = int(um.get("unit_points", s.unit_points))
		s.unit_slots = _deserialize_unit_slots(um.get("unit_slots", []))
		s.unit_recruits = um.get("unit_recruits", s.unit_recruits)
		s.unit_reserves = _deserialize_unit_slots(um.get("unit_reserves", []))

	var content: Dictionary = json.get("content", {})
	if typeof(content) == TYPE_DICTIONARY:
		s.units = content.get("units", s.units)
		s.triggers = content.get("triggers", s.triggers)
		s.tasks = content.get("tasks", s.tasks)
		s.drawings = content.get("drawings", s.drawings)

	if typeof(s.preview_path) == TYPE_STRING and s.preview_path != "":
		var tex := load(s.preview_path)
		if tex is Texture2D:
			s.preview = tex
	if typeof(s.terrain_path) == TYPE_STRING and s.terrain_path != "":
		var ter := load(s.terrain_path)
		if ter is TerrainData:
			s.terrain = ter

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
