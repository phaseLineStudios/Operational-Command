# Persistence::delete_save Function Reference

*Defined at:* `scripts/core/Persistence.gd` (lines 147–163)</br>
*Belongs to:* [Persistence](../../Persistence.md)

**Signature**

```gdscript
func delete_save(save_id: String) -> bool
```

## Description

Delete a save by ID. Returns true on success.

## Source

```gdscript
func delete_save(save_id: String) -> bool:
	var file_path := _get_save_path(save_id)

	if not FileAccess.file_exists(file_path):
		push_warning("Cannot delete save: file not found %s" % file_path)
		return false

	var err := DirAccess.remove_absolute(file_path)
	if err != OK:
		push_error("Failed to delete save file: %s" % file_path)
		return false

	_save_cache.erase(save_id)
	LogService.info("Deleted save: %s" % save_id, "Persistence")
	return true
```
