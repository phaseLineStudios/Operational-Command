# ContentDB::get_scenarios Function Reference

*Defined at:* `scripts/core/ContentDB.gd` (lines 166–174)</br>
*Belongs to:* [ContentDB](../../ContentDB.md)

**Signature**

```gdscript
func get_scenarios(ids: Array) -> Array[ScenarioData]
```

## Description

Get multiple scenarios by IDs

## Source

```gdscript
func get_scenarios(ids: Array) -> Array[ScenarioData]:
	var out: Array[ScenarioData] = []
	for raw in ids:
		var s := get_scenario(String(raw))
		if s:
			out.append(s)
	return out
```
