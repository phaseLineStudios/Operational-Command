# ContentDB::get_all_objects Function Reference

*Defined at:* `scripts/core/ContentDB.gd` (lines 74–89)</br>
*Belongs to:* [ContentDB](../../ContentDB.md)

**Signature**

```gdscript
func get_all_objects(dir_path: String) -> Array
```

## Description

Read all objects in a directory.

## Source

```gdscript
func get_all_objects(dir_path: String) -> Array:
	var dir_abs := _norm_dir(dir_path)
	var out: Array = []
	var files := DirAccess.get_files_at(dir_abs)
	if files.is_empty():
		return out
	for f in files:
		if f.get_extension().to_lower() != "json":
			continue
		var path := "%s/%s" % [dir_abs, f]
		var obj := _load_json(path)
		if not obj.is_empty():
			out.append(obj)
	return out
```
