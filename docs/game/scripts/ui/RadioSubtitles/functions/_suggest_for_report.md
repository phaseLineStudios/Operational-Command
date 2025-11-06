# RadioSubtitles::_suggest_for_report Function Reference

*Defined at:* `scripts/ui/RadioSubtitles.gd` (lines 233–239)</br>
*Belongs to:* [RadioSubtitles](../../RadioSubtitles.md)

**Signature**

```gdscript
func _suggest_for_report(_state: Dictionary, _last_token: String) -> Array[String]
```

## Description

Suggestions for REPORT command

## Source

```gdscript
func _suggest_for_report(_state: Dictionary, _last_token: String) -> Array[String]:
	var suggestions: Array[String] = []
	# Suggest report types
	suggestions.append_array(["Status", "Contact", "Position", "Ammunition", "Casualties"])
	return suggestions
```
