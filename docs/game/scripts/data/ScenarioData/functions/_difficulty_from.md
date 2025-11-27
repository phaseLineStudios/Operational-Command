# ScenarioData::_difficulty_from Function Reference

*Defined at:* `scripts/data/ScenarioData.gd` (lines 282–293)</br>
*Belongs to:* [ScenarioData](../../ScenarioData.md)

**Signature**

```gdscript
func _difficulty_from(json_value: Variant) -> int
```

## Source

```gdscript
static func _difficulty_from(json_value: Variant) -> int:
	if typeof(json_value) == TYPE_INT:
		return clamp(int(json_value), 0, 2)
	if typeof(json_value) == TYPE_STRING:
		match String(json_value).to_lower():
			"easy":
				return ScenarioDifficulty.EASY
			"normal":
				return ScenarioDifficulty.NORMAL
			"hard":
				return ScenarioDifficulty.HARD
	return ScenarioDifficulty.NORMAL
```
