# STTService::_extract_final_text Function Reference

*Defined at:* `scripts/radio/STTService.gd` (lines 161–169)</br>
*Belongs to:* [STTService](../STTService.md)

**Signature**

```gdscript
func _extract_final_text(raw: String) -> String
```

## Description

Extract final text from Vosk's result(), which may be JSON or plain text.

## Source

```gdscript
func _extract_final_text(raw: String) -> String:
	var s := raw.strip_edges()
	if s.begins_with("{"):
		var j: Dictionary = JSON.parse_string(s)
		if typeof(j) == TYPE_DICTIONARY and j.has("text"):
			return String(j["text"]).strip_edges()
	return s
```
