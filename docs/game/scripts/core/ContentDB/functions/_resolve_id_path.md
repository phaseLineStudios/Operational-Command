# ContentDB::_resolve_id_path Function Reference

*Defined at:* `scripts/core/ContentDB.gd` (lines 69–73)</br>
*Belongs to:* [ContentDB](../../ContentDB.md)

**Signature**

```gdscript
func _resolve_id_path(dir_abs: String, id: String) -> String
```

## Description

Get absolute file path for id in a directory.

## Source

```gdscript
func _resolve_id_path(dir_abs: String, id: String) -> String:
	var candidate := "%s/%s.json" % [dir_abs, id]
	return candidate if FileAccess.file_exists(candidate) else ""
```
