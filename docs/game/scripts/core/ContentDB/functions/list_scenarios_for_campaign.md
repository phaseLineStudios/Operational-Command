# ContentDB::list_scenarios_for_campaign Function Reference

*Defined at:* `scripts/core/ContentDB.gd` (lines 229–268)</br>
*Belongs to:* [ContentDB](../../ContentDB.md)

**Signature**

```gdscript
func list_scenarios_for_campaign(campaign_id: StringName) -> Array[ScenarioData]
```

## Description

List all scenarios for a campaign by ID

## Source

```gdscript
func list_scenarios_for_campaign(campaign_id: StringName) -> Array[ScenarioData]:
	var camp := get_object("campaigns", String(campaign_id))
	if camp.is_empty():
		push_warning("Campaign not found: %s" % campaign_id)
		return []

	var ids: Array = []
	if typeof(camp["scenarios"]) == TYPE_ARRAY:
		ids = camp["scenarios"]
	else:
		push_warning("Campaign missing 'scenarios' array: %s" % campaign_id)
		return []

	var decorated: Array = []
	var i := 0
	for id_val in ids:
		var id_str := String(id_val)
		var m_dict := get_object("scenarios", id_str)
		var order := 2147483647
		if not m_dict.is_empty():
			if m_dict.has("order"):
				order = int(m_dict["order"])
			elif m_dict.has("scenario_order"):
				order = int(m_dict["scenario_order"])
		else:
			push_warning("Scenario not found for id: %s" % id_str)
		decorated.append([order, i, id_str])
		i += 1

	decorated.sort_custom(func(a, b): return a[1] < b[1] if a[0] == b[0] else a[0] < b[0])

	var out: Array[ScenarioData] = []
	for item in decorated:
		var mid := String(item[2])
		var m_res := get_scenario(mid)
		if m_res != null:
			out.append(m_res)
	return out
```
