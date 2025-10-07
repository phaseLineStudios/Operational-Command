# ContentDB::_norm_dir Function Reference

*Defined at:* `scripts/core/ContentDB.gd` (lines 12–20)</br>
*Belongs to:* [ContentDB](../../ContentDB.md)

**Signature**

```gdscript
func _norm_dir(dir_path: String) -> String
```

## Description

Normalize to res:// and remove trailing slash.

## Source

```gdscript
func _norm_dir(dir_path: String) -> String:
	var p := dir_path
	if not p.begins_with("res://data/"):
		p = "res://data/" + p
	if p.ends_with("/"):
		p = p.substr(0, p.length() - 1)
	return p
```
