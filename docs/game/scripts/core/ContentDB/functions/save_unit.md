# ContentDB::save_unit Function Reference

*Defined at:* `scripts/core/ContentDB.gd` (lines 361–382)</br>
*Belongs to:* [ContentDB](../../ContentDB.md)

**Signature**

```gdscript
func save_unit(unit: UnitData) -> String
```

- **unit**: UnitData to save.
- **Return Value**: Absolute path or "" on error.

## Description

Save a UnitData to res://data/units/<id>.json and update cache.

## Source

```gdscript
func save_unit(unit: UnitData) -> String:
	if unit == null or String(unit.id).strip_edges() == "":
		push_warning("save_unit: missing unit or id")
		return ""
	var dir_abs := _norm_dir("units")
	var mk := DirAccess.make_dir_recursive_absolute(dir_abs)
	if mk != OK and mk != ERR_ALREADY_EXISTS:
		push_warning("save_unit: cannot create %s (err %d)" % [dir_abs, mk])
		return ""
	var abs_path := "%s/%s.json" % [dir_abs, unit.id]
	var f := FileAccess.open(abs_path, FileAccess.WRITE)
	if f == null:
		push_warning("save_unit: cannot open %s (err %d)" % [abs_path, FileAccess.get_open_error()])
		return ""
	var payload := unit.serialize().duplicate(true)
	f.store_string(JSON.stringify(payload, "  "))
	f.flush()
	f.close()
	_cache[abs_path] = payload
	return abs_path
```
