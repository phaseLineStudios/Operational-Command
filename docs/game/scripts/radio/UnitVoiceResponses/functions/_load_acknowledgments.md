# UnitVoiceResponses::_load_acknowledgments Function Reference

*Defined at:* `scripts/radio/UnitVoiceResponses.gd` (lines 49–80)</br>
*Belongs to:* [UnitVoiceResponses](../../UnitVoiceResponses.md)

**Signature**

```gdscript
func _load_acknowledgments() -> void
```

## Description

Load acknowledgment phrases from JSON data file.

## Source

```gdscript
func _load_acknowledgments() -> void:
	if not FileAccess.file_exists(ACKNOWLEDGMENTS_PATH):
		push_error("UnitVoiceResponses: Acknowledgments file not found: %s" % ACKNOWLEDGMENTS_PATH)
		return

	var file := FileAccess.open(ACKNOWLEDGMENTS_PATH, FileAccess.READ)
	if file == null:
		push_error(
			"UnitVoiceResponses: Failed to open acknowledgments file: %s" % ACKNOWLEDGMENTS_PATH
		)
		return

	var json_text := file.get_as_text()
	file.close()

	var json := JSON.new()
	var error := json.parse(json_text)
	if error != OK:
		push_error(
			(
				"UnitVoiceResponses: Failed to parse acknowledgments JSON at line %d: %s"
				% [json.get_error_line(), json.get_error_message()]
			)
		)
		return

	acknowledgments = json.data
	LogService.info(
		"Loaded %d acknowledgment categories" % acknowledgments.size(), "UnitVoiceResponses"
	)
```
