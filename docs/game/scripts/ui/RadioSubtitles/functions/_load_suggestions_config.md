# RadioSubtitles::_load_suggestions_config Function Reference

*Defined at:* `scripts/ui/RadioSubtitles.gd` (lines 40–67)</br>
*Belongs to:* [RadioSubtitles](../../RadioSubtitles.md)

**Signature**

```gdscript
func _load_suggestions_config() -> void
```

## Description

Load suggestions configuration from JSON

## Source

```gdscript
func _load_suggestions_config() -> void:
	if not FileAccess.file_exists(SUGGESTIONS_PATH):
		push_error("RadioSubtitles: Suggestions config not found: %s" % SUGGESTIONS_PATH)
		return

	var file := FileAccess.open(SUGGESTIONS_PATH, FileAccess.READ)
	if file == null:
		push_error("RadioSubtitles: Failed to open suggestions config: %s" % SUGGESTIONS_PATH)
		return

	var json_text := file.get_as_text()
	file.close()

	var json := JSON.new()
	var error := json.parse(json_text)
	if error != OK:
		push_error(
			(
				"RadioSubtitles: Failed to parse suggestions JSON at line %d: %s"
				% [json.get_error_line(), json.get_error_message()]
			)
		)
		return

	_suggestions_config = json.data
	LogService.info("Loaded radio suggestions config", "RadioSubtitles")
```
