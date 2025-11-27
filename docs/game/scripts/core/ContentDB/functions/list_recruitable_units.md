# ContentDB::list_recruitable_units Function Reference

*Defined at:* `scripts/core/ContentDB.gd` (lines 413–443)</br>
*Belongs to:* [ContentDB](../../ContentDB.md)

**Signature**

```gdscript
func list_recruitable_units(mission_id: String) -> Array[UnitData]
```

## Description

Get list of reqreuitable units for scenario

## Source

```gdscript
func list_recruitable_units(mission_id: String) -> Array[UnitData]:
	var mission := get_object("scenarios", mission_id)
	if mission.is_empty():
		push_warning("Mission not found: %s" % mission_id)
		return []

	var ids: Array = []
	if mission.has("recruitable_units") and typeof(mission["recruitable_units"]) == TYPE_ARRAY:
		# legacy/simple schema
		ids = mission["recruitable_units"]
	elif mission.has("units") and typeof(mission["units"]) == TYPE_DICTIONARY:
		var um: Dictionary = mission["units"]
		if um.has("unit_recruits_ids") and typeof(um["unit_recruits_ids"]) == TYPE_ARRAY:
			# new schema produced by ScenarioData.serialize()
			ids = um["unit_recruits_ids"]
		else:
			push_warning("Mission 'units' present but missing 'unit_recruits_ids': %s" % mission_id)
	else:
		push_warning("Mission missing recruitable units list: %s" % mission_id)
		return []

	var out: Array[UnitData] = []
	for id_val in ids:
		var u := get_unit(String(id_val))
		if u != null:
			out.append(u)
		else:
			push_warning("Unit not found for id: %s" % String(id_val))
	return out
```
