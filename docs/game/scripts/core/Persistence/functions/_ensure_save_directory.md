# Persistence::_ensure_save_directory Function Reference

*Defined at:* `scripts/core/Persistence.gd` (lines 18–24)</br>
*Belongs to:* [Persistence](../../Persistence.md)

**Signature**

```gdscript
func _ensure_save_directory() -> void
```

## Description

Ensure the save directory exists.

## Source

```gdscript
func _ensure_save_directory() -> void:
	if not DirAccess.dir_exists_absolute(SAVE_DIR):
		var err := DirAccess.make_dir_recursive_absolute(SAVE_DIR)
		if err != OK:
			push_error("Failed to create save directory: %s" % SAVE_DIR)
```
