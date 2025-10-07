# SmokeCompile::_walk_dir Function Reference

*Defined at:* `tools/ci/smoke_compile.gd` (lines 55–78)</br>
*Belongs to:* [SmokeCompile](../../SmokeCompile.md)

**Signature**

```gdscript
func _walk_dir(dir_path: String, out: PackedStringArray) -> void
```

## Description

Walk directories

## Source

```gdscript
func _walk_dir(dir_path: String, out: PackedStringArray) -> void:
	for e in exclude_dirs:
		if dir_path.begins_with(e):
			return
	var dir := DirAccess.open(dir_path)
	if dir == null:
		push_error("Cannot open dir: %s" % dir_path)
		return
	dir.list_dir_begin()
	while true:
		var name := dir.get_next()
		if name == "":
			break
		if name.begins_with("."):
			continue
		var full := dir_path.path_join(name)
		if dir.current_is_dir():
			_walk_dir(full, out)
		else:
			for ext in include_exts:
				if full.ends_with(ext):
					out.append(full)
					break
	dir.list_dir_end()
```
