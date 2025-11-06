# RadioSubtitles::_get_action_suggestions Function Reference

*Defined at:* `scripts/ui/RadioSubtitles.gd` (lines 292–303)</br>
*Belongs to:* [RadioSubtitles](../../RadioSubtitles.md)

**Signature**

```gdscript
func _get_action_suggestions() -> Array[String]
```

## Description

Get action suggestions

## Source

```gdscript
func _get_action_suggestions() -> Array[String]:
	var suggestions: Array[String] = []
	var actions: Dictionary = _tables.get("action_synonyms", {})
	var seen := {}
	for key in actions.keys():
		var action_type: int = actions[key]
		if not seen.has(action_type):
			seen[action_type] = true
			suggestions.append(str(key).capitalize())
	return suggestions
```
