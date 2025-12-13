# ScenarioData::deserialize Function Reference

*Defined at:* `scripts/data/ScenarioData.gd` (lines 166–280)</br>
*Belongs to:* [ScenarioData](../../ScenarioData.md)

**Signature**

```gdscript
func deserialize(json: Variant) -> ScenarioData
```

## Description

Deserialize data from JSON

## Source

```gdscript
static func deserialize(json: Variant) -> ScenarioData:
	if typeof(json) != TYPE_DICTIONARY:
		return null

	var s := ScenarioData.new()
	s.id = json.get("id", s.id)
	s.title = json.get("title", s.title)
	s.description = json.get("description", s.description)
	s.preview_path = json.get("preview_path", s.preview_path)
	s.video_path = json.get("video_path", s.video_path)

	var terr_id: Variant = json.get("terrain_id", null)
	if typeof(terr_id) == TYPE_STRING and terr_id != "":
		s.terrain = ContentDB.get_terrain(terr_id)

	var brief_val: Variant = json.get("briefing", null)
	if brief_val != null:
		s.briefing = BriefData.deserialize(brief_val)

	var subtitles_val: Variant = json.get("video_subtitles", null)
	if subtitles_val != null and typeof(subtitles_val) == TYPE_DICTIONARY:
		var track := SubtitleTrack.new()
		track.deserialize(subtitles_val)
		s.video_subtitles = track

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
		s.replacement_pool = int(um.get("replacement_pool", 0))
		s.equipment_pool = int(um.get("equipment_pool", 100))

		var ammo_pools_data = um.get("ammo_pools", {})
		if typeof(ammo_pools_data) == TYPE_DICTIONARY:
			s.ammo_pools = ammo_pools_data.duplicate()

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

		var placed_drawings: Array = content.get("drawings", [])
		if typeof(placed_drawings) == TYPE_ARRAY:
			var out: Array = []
			for raw in placed_drawings:
				var d := ScenarioDrawing.deserialize(raw)
				if d != null:
					out.append(d)
			s.drawings = out

		var placed_custom_commands: Array = content.get("custom_commands", [])
		if typeof(placed_custom_commands) == TYPE_ARRAY:
			var cmds: Array[CustomCommand] = []
			for raw in placed_custom_commands:
				var cmd := CustomCommand.deserialize(raw)
				if cmd != null:
					cmds.append(cmd)
			s.custom_commands = cmds

	if typeof(s.preview_path) == TYPE_STRING and s.preview_path != "":
		var tex := load(s.preview_path)
		if tex is Texture2D:
			s.preview = tex

	if typeof(s.video_path) == TYPE_STRING and s.video_path != "":
		var vid := load(s.video_path)
		if vid is VideoStream:
			s.video = vid

	return s
```
