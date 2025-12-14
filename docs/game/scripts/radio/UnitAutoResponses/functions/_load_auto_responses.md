# UnitAutoResponses::_load_auto_responses Function Reference

*Defined at:* `scripts/radio/UnitAutoResponses.gd` (lines 121–167)</br>
*Belongs to:* [UnitAutoResponses](../../UnitAutoResponses.md)

**Signature**

```gdscript
func _load_auto_responses() -> void
```

## Description

Load auto response phrases from JSON data file.

## Source

```gdscript
func _load_auto_responses() -> void:
	if not FileAccess.file_exists(AUTO_RESPONSES_PATH):
		push_error("UnitAutoResponses: Auto responses file not found: %s" % AUTO_RESPONSES_PATH)
		return

	var file := FileAccess.open(AUTO_RESPONSES_PATH, FileAccess.READ)
	if file == null:
		push_error(
			"UnitAutoResponses: Failed to open auto responses file: %s" % AUTO_RESPONSES_PATH
		)
		return

	var json_text := file.get_as_text()
	file.close()

	var json := JSON.new()
	var error := json.parse(json_text)
	if error != OK:
		push_error(
			(
				"UnitAutoResponses: Failed to parse auto responses JSON at line %d: %s"
				% [json.get_error_line(), json.get_error_message()]
			)
		)
		return

	var data: Dictionary = json.data

	var events_json: Dictionary = data.get("events", {})
	for event_name in events_json.keys():
		var event_type := _event_name_to_enum(event_name)
		if event_type != -1:
			event_config[event_type] = events_json[event_name]

	order_failure_phrases = data.get("order_failures", {})
	movement_blocked_phrases = data.get("movement_blocked", {})
	commander_names = data.get("commander_names", [])

	LogService.info(
		(
			"Loaded %d event configs, %d order failure types, %d movement blocked types"
			% [event_config.size(), order_failure_phrases.size(), movement_blocked_phrases.size()]
		),
		"UnitAutoResponses"
	)
```
