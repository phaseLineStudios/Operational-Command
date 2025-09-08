extends Resource
class_name BriefData

## Unique identifier for this briefing
@export var id: String
## Human-readable title of the briefing
@export var title: String

@export_category("WARNO - Situation")
## Enemy situation fragment (enemy composition, disposition, activity)
@export var frag_enemy: String
## Friendly situation fragment (own forces/adjacent/supporting)
@export var frag_friendly: String
## Terrain and obstacles fragment (key terrain, avenues of approach)
@export var frag_terrain: String
## Weather fragment (visibility, precipitation, wind, effects)
@export var frag_weather: String
## Start time / H-Hour context fragment
@export var frag_start_time: String

@export_category("WARNO - Mission")
## Mission statement fragment (task & purpose)
@export var frag_mission: String
## Objectives list
@export var frag_objectives: Array

@export_category("WARNO - Execution")
## Execution guidance (e.g., scheme of maneuver)
@export var frag_execution: Array[String]

@export_category("WARNO - Admin & Logi")
## Administration & logistics fragment
@export var frago_logi: String

@export_category("Intel Board")
## Background texture for the intel/briefing board
@export var board_texture: Texture2D
## Items pinned on the intel board (documents, images, etc.)
@export var board_items: Array[BriefItemData]

## Serializes briefing data to JSON
func serialize() -> Dictionary:
	var items: Array = []
	for it in board_items:
		items.append(it.serialize())

	return {
		"id": id,
		"title": title,

		"situation": {
			"enemy": frag_enemy,
			"friendly": frag_friendly,
			"terrain": frag_terrain,
			"weather": frag_weather,
			"start_time": frag_start_time
		},

		"mission": {
			"statement": frag_mission,
			"objectives": frag_objectives.duplicate()
		},

		"execution": frag_execution.duplicate(),
		"admin_logi": frago_logi,

		"intel_board": {
			"board_texture_path": (board_texture.resource_path if board_texture and board_texture.resource_path != "" else null),
			"items": items
		}
	}

## Deserializes briefing data from JSON
static func deserialize(data: Variant) -> BriefData:
	if typeof(data) != TYPE_DICTIONARY:
		return null

	var b := BriefData.new()

	b.id = data.get("id", b.id)
	b.title = data.get("title", b.title)

	var sit: Dictionary = data.get("situation", {})
	if typeof(sit) == TYPE_DICTIONARY:
		b.frag_enemy = sit.get("enemy", b.frag_enemy)
		b.frag_friendly = sit.get("friendly", b.frag_friendly)
		b.frag_terrain = sit.get("terrain", b.frag_terrain)
		b.frag_weather = sit.get("weather", b.frag_weather)
		b.frag_start_time = sit.get("start_time", b.frag_start_time)

	var mis: Dictionary = data.get("mission", {})
	if typeof(mis) == TYPE_DICTIONARY:
		b.frag_mission = mis.get("statement", b.frag_mission)
		b.frag_objectives = mis.get("objectives", b.frag_objectives)

	var exe: Dictionary = data.get("execution", b.frag_execution)
	if typeof(exe) == TYPE_ARRAY:
		var tmp: Array[String] = []
		for e in exe:
			tmp.append(str(e))
		b.frag_execution = tmp

	b.frago_logi = data.get("admin_logi", b.frago_logi)

	var intel: Dictionary = data.get("intel_board", {})
	if typeof(intel) == TYPE_DICTIONARY:
		# Texture
		var tex_path = intel.get("board_texture_path", null)
		if tex_path != null and typeof(tex_path) == TYPE_STRING and tex_path != "":
			var tex := load(tex_path)
			if tex is Texture2D:
				b.board_texture = tex

		var items = intel.get("items", [])
		if typeof(items) == TYPE_ARRAY:
			var out_items: Array[BriefItemData] = []
			for it in items:
				if typeof(it) == TYPE_DICTIONARY:
					var bi := BriefItemData.deserialize(it)
					if bi:
						out_items.append(bi)
			b.board_items = out_items

	return b
