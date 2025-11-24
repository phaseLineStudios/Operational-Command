# Persistence::load_save_from_file Function Reference

*Defined at:* `scripts/core/Persistence.gd` (lines 91–119)</br>
*Belongs to:* [Persistence](../../Persistence.md)

**Signature**

```gdscript
func load_save_from_file(save_id: String) -> CampaignSave
```

## Description

Load a save from file by ID. Returns null if not found.

## Source

```gdscript
func load_save_from_file(save_id: String) -> CampaignSave:
	var file_path := _get_save_path(save_id)

	if not FileAccess.file_exists(file_path):
		return null

	var file := FileAccess.open(file_path, FileAccess.READ)
	if not file:
		push_error("Failed to open save file: %s" % file_path)
		return null

	var json_string := file.get_as_text()
	file.close()

	var json := JSON.new()
	var parse_result := json.parse(json_string)
	if parse_result != OK:
		push_error(
			"Failed to parse save file: %s (error at line %d)" % [file_path, json.get_error_line()]
		)
		return null

	var save: CampaignSave = CampaignSave.deserialize(json.data)
	if save:
		_save_cache[save_id] = save

	return save
```
