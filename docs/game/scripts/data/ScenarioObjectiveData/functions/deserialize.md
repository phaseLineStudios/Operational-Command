# ScenarioObjectiveData::deserialize Function Reference

*Defined at:* `scripts/data/ScenarioObjectiveData.gd` (lines 20–30)</br>
*Belongs to:* [ScenarioObjectiveData](../ScenarioObjectiveData.md)

**Signature**

```gdscript
func deserialize(data: Variant) -> ScenarioObjectiveData
```

## Description

Deserialize from JSON

## Source

```gdscript
static func deserialize(data: Variant) -> ScenarioObjectiveData:
	if typeof(data) != TYPE_DICTIONARY:
		return null

	var o := ScenarioObjectiveData.new()
	o.id = data.get("id", o.id)
	o.title = data.get("title", o.title)
	o.success = data.get("success", o.success)
	o.score = int(data.get("score", o.score))

	return o
```
