# CampaignData::deserialize Function Reference

*Defined at:* `scripts/data/CampaignData.gd` (lines 55–88)</br>
*Belongs to:* [CampaignData](../../CampaignData.md)

**Signature**

```gdscript
func deserialize(data: Variant) -> CampaignData
```

## Description

Deserialize Campaign data from JSON

## Source

```gdscript
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
```
