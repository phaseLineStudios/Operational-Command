# BriefData::deserialize Function Reference

*Defined at:* `scripts/data/BriefData.gd` (lines 79–129)</br>
*Belongs to:* [BriefData](../../BriefData.md)

**Signature**

```gdscript
func deserialize(data: Variant) -> BriefData
```

## Description

Deserializes briefing data from JSON

## Source

```gdscript
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
```
