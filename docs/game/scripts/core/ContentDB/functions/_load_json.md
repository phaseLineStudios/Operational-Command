# ContentDB::_load_json Function Reference

*Defined at:* `scripts/core/ContentDB.gd` (lines 50–67)</br>
*Belongs to:* [ContentDB](../../ContentDB.md)

**Signature**

```gdscript
func _load_json(abs_path: String) -> Dictionary
```

## Description

Load a JSON file to Dictionary. Uses cache.

## Source

```gdscript
func _load_json(abs_path: String) -> Dictionary:
	if _cache.has(abs_path):
		return _cache[abs_path]
	if not FileAccess.file_exists(abs_path):
		return {}
	var txt := FileAccess.get_file_as_string(abs_path)
	var parsed: Variant = JSON.parse_string(txt)
	if parsed == null:
		push_warning("JSON parse failed: %s" % abs_path)
		return {}
	var cooked: Variant = _postprocess(parsed)
	if typeof(cooked) != TYPE_DICTIONARY:
		push_warning("Top-level JSON is not an object: %s" % abs_path)
		return {}
	_cache[abs_path] = cooked
	return cooked
```
