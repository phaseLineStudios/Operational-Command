# RadioSubtitles::_get_action_suggestions Function Reference

*Defined at:* `scripts/ui/RadioSubtitles.gd` (lines 336–344)</br>
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
	# Use config to get actions in proper order
	var actions_config = _suggestions_config.get("actions", {})
	for action in actions_config.keys():
		suggestions.append(str(action).capitalize())
	return suggestions
```
