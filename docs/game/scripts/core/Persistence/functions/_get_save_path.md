# Persistence::_get_save_path Function Reference

*Defined at:* `scripts/core/Persistence.gd` (lines 165–166)</br>
*Belongs to:* [Persistence](../../Persistence.md)

**Signature**

```gdscript
func _get_save_path(save_id: String) -> String
```

## Description

Get the file path for a save ID.

## Source

```gdscript
func _get_save_path(save_id: String) -> String:
	return SAVE_DIR.path_join(save_id + ".json")
```
