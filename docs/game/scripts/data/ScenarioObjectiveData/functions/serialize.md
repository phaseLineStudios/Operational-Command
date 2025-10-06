# ScenarioObjectiveData::serialize Function Reference

*Defined at:* `scripts/data/ScenarioObjectiveData.gd` (lines 15–18)</br>
*Belongs to:* [ScenarioObjectiveData](../ScenarioObjectiveData.md)

**Signature**

```gdscript
func serialize() -> Dictionary
```

## Description

Serialize into JSON

## Source

```gdscript
func serialize() -> Dictionary:
	return {"id": id, "title": title, "success": success, "score": score}
```
