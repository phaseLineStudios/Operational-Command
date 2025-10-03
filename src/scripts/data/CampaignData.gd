extends Resource
class_name CampaignData

## Unique identifier for this campaign
@export var id: String
## Human-readable title of the campaign
@export var title: String
## Description of the campaign, shown to the player
@export var description: String
## Preview image for the campaign
@export var preview: Texture2D
## Background texture for the scenario selection screen
@export var scenario_bg: Texture2D
## List of scenarios that make up this campaign
@export var scenarios: Array[ScenarioData]
## Order index for this campaign
@export var order: int = 0

@export_category("content")
## Saved states of this campaign (future campaign save structure).
@export var saves: Array = []


## Serialize campaign data to JSON
func serialize() -> Dictionary:
	var scenario_dicts: Array = []
	for sc in scenarios:
		scenario_dicts.append(sc.serialize())

	return {
		"id": id,
		"title": title,
		"description": description,
		"preview_path":
		preview.resource_path as Variant if preview and preview.resource_path != "" else null as Variant,
		"scenario_bg_path":
		scenario_bg.resource_path as Variant if scenario_bg and scenario_bg.resource_path != "" else null as Variant,
		"scenarios": scenario_dicts,
		"order": order,
		"saves": saves.duplicate()
	}


## Deserialize Campaign data from JSON
static func deserialize(data: Variant) -> CampaignData:
	if typeof(data) != TYPE_DICTIONARY:
		return null

	var c := CampaignData.new()
	c.id = data.get("id", c.id)
	c.title = data.get("title", c.title)
	c.description = data.get("description", c.description)
	c.order = int(data.get("order", c.order))
	c.saves = data.get("saves", c.saves)

	var prev_path = data.get("preview_path", null)
	if prev_path != null and typeof(prev_path) == TYPE_STRING and prev_path != "":
		var tex := load(prev_path)
		if tex is Texture2D:
			c.preview = tex

	var bg_path = data.get("scenario_bg_path", null)
	if bg_path != null and typeof(bg_path) == TYPE_STRING and bg_path != "":
		var bg := load(bg_path)
		if bg is Texture2D:
			c.scenario_bg = bg

	var scs = data.get("scenarios", [])
	if typeof(scs) == TYPE_ARRAY:
		var tmp: Array[ScenarioData] = []
		for entry in scs:
			if typeof(entry) == TYPE_DICTIONARY:
				var sc := ScenarioData.deserialize(entry)
				if sc:
					tmp.append(sc)
		c.scenarios = tmp

	return c
