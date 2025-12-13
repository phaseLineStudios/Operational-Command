# ContentDB::get_all_objects Function Reference

*Defined at:* `scripts/core/ContentDB.gd` (lines 75–89)</br>
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
	var files := ResourceLoader.list_directory(dir_abs)
	for file in files:
		var is_dir := file[file.length() - 1] == "/"
		var extension := file.split(".")[-1]
		if not is_dir and extension in ["json"]:
			var path := "%s/%s" % [dir_abs, file]
			var obj := _load_json(path)
			if not obj.is_empty():
				out.append(obj)
	return out
```
