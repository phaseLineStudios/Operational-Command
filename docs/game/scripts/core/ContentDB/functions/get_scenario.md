# ContentDB::get_scenario Function Reference

*Defined at:* `scripts/core/ContentDB.gd` (lines 157–164)</br>
*Belongs to:* [ContentDB](../../ContentDB.md)

**Signature**

```gdscript
func get_scenario(id: String) -> ScenarioData
```

## Description

Missions helpers.
Get Mission by ID

## Source

```gdscript
func get_scenario(id: String) -> ScenarioData:
	var d := get_object("scenarios", id)
	if d.is_empty():
		push_warning("Mission not found: %s" % id)
		return null
	return ScenarioData.deserialize(d)
```
