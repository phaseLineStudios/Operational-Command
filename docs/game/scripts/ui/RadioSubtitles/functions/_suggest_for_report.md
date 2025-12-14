# RadioSubtitles::_suggest_for_report Function Reference

*Defined at:* `scripts/ui/RadioSubtitles.gd` (lines 275–283)</br>
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
	# Get report types from config
	var report_types_config = _suggestions_config.get("report_types", {})
	for report_type in report_types_config.keys():
		suggestions.append(str(report_type).capitalize())
	return suggestions
```
