# ContentDB::get_object Function Reference

*Defined at:* `scripts/core/ContentDB.gd` (lines 91–96)</br>
*Belongs to:* [ContentDB](../ContentDB.md)

**Signature**

```gdscript
func get_object(dir_path: String, id: String) -> Dictionary
```

## Description

Read a single object by id.

## Source

```gdscript
func get_object(dir_path: String, id: String) -> Dictionary:
	var dir_abs := _norm_dir(dir_path)
	var path := _resolve_id_path(dir_abs, id)
	return {} if path == "" else _load_json(path)
```
