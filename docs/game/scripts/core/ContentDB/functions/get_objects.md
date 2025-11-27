# ContentDB::get_objects Function Reference

*Defined at:* `scripts/core/ContentDB.gd` (lines 97–107)</br>
*Belongs to:* [ContentDB](../../ContentDB.md)

**Signature**

```gdscript
func get_objects(dir_path: String, ids: Array) -> Array
```

## Description

Read multiple objects by ids (keeps order).

## Source

```gdscript
func get_objects(dir_path: String, ids: Array) -> Array:
	var dir_abs := _norm_dir(dir_path)
	var out: Array = []
	out.resize(ids.size())
	for i in ids.size():
		var id_str := String(ids[i])
		var path := _resolve_id_path(dir_abs, id_str)
		out[i] = {} if path == "" else _load_json(path)
	return out
```
