# ScenarioData::_dict_to_vec2 Function Reference

*Defined at:* `scripts/data/ScenarioData.gd` (lines 248–255)</br>
*Belongs to:* [ScenarioData](../../ScenarioData.md)

**Signature**

```gdscript
func _dict_to_vec2(d: Variant) -> Vector2
```

## Source

```gdscript
static func _dict_to_vec2(d: Variant) -> Vector2:
	if typeof(d) == TYPE_DICTIONARY and d.has("x") and d.has("y"):
		return Vector2(float(d["x"]), float(d["y"]))
	if typeof(d) == TYPE_ARRAY and d.size() >= 2:
		return Vector2(float(d[0]), float(d[1]))
	return Vector2.ZERO
```
