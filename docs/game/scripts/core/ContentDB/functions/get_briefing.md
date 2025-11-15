# ContentDB::get_briefing Function Reference

*Defined at:* `scripts/core/ContentDB.gd` (lines 270–289)</br>
*Belongs to:* [ContentDB](../../ContentDB.md)

**Signature**

```gdscript
func get_briefing(id_or_mission_id: String) -> BriefData
```

## Description

Briefing helpers.
Get a briefing by id or by mission id

## Source

```gdscript
func get_briefing(id_or_mission_id: String) -> BriefData:
	var brief_d := get_object("briefs", id_or_mission_id)
	if brief_d.is_empty():
		var m_json := get_object("scenarios", id_or_mission_id)
		if m_json.is_empty():
			return null
		var link_id := ""
		if m_json.has("briefing"):
			link_id = String(m_json["briefing"])
		if link_id != "":
			brief_d = get_object("briefs", link_id)
			if brief_d.is_empty():
				return null
		elif m_json.has("briefing") and typeof(m_json["briefing"]) == TYPE_DICTIONARY:
			brief_d = m_json["briefing"]
			if typeof(brief_d) != TYPE_DICTIONARY:
				return null
	return BriefData.deserialize(brief_d)
```
