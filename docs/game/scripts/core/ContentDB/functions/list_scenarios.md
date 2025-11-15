# ContentDB::list_scenarios Function Reference

*Defined at:* `scripts/core/ContentDB.gd` (lines 175–187)</br>
*Belongs to:* [ContentDB](../../ContentDB.md)

**Signature**

```gdscript
func list_scenarios() -> Array[ScenarioData]
```

## Description

list all scenarios

## Source

```gdscript
func list_scenarios() -> Array[ScenarioData]:
	var camps := get_all_objects("scenarios")
	if camps.is_empty():
		return []

	var out: Array[ScenarioData] = []
	for item in camps:
		var res := ScenarioData.deserialize(item)
		if res != null:
			out.append(res)
	return out
```
