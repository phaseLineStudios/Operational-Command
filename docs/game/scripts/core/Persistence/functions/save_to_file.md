# Persistence::save_to_file Function Reference

*Defined at:* `scripts/core/Persistence.gd` (lines 121–145)</br>
*Belongs to:* [Persistence](../../Persistence.md)

**Signature**

```gdscript
func save_to_file(save: CampaignSave) -> bool
```

## Description

Save a CampaignSave to file.

## Source

```gdscript
func save_to_file(save: CampaignSave) -> bool:
	if not save:
		push_error("Cannot save null CampaignSave")
		return false

	_ensure_save_directory()

	save.touch()  # Update last played timestamp

	var file_path := _get_save_path(save.save_id)
	var file := FileAccess.open(file_path, FileAccess.WRITE)
	if not file:
		push_error("Failed to create save file: %s" % file_path)
		return false

	var data := save.serialize()
	var json_string := JSON.stringify(data, "\t")
	file.store_string(json_string)
	file.close()

	_save_cache[save.save_id] = save
	LogService.info("Saved campaign progress to: %s" % file_path, "Persistence")
	return true
```
