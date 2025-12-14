# DebugMenu::_recursive_collect_scenes Function Reference

*Defined at:* `scripts/ui/DebugMenu.gd` (lines 120–140)</br>
*Belongs to:* [DebugMenu](../../DebugMenu.md)

**Signature**

```gdscript
func _recursive_collect_scenes(path: String, out: Array) -> void
```

## Description

recursivly collect all scenes in project

## Source

```gdscript
func _recursive_collect_scenes(path: String, out: Array) -> void:
	if path.ends_with("/.godot") or path.ends_with("/.import"):
		return

	var files := ResourceLoader.list_directory(path)
	for file in files:
		var is_dir := file[file.length() - 1] == "/"
		var extension := file.split(".")[-1]
		if not is_dir and extension in ["tscn", "scn"]:
			out.append(path.path_join(file))

		if is_dir:
			if (
				file.begins_with(".git")
				or file.begins_with(".godot")
				or file.begins_with(".import")
			):
				continue
			_recursive_collect_scenes(path.path_join(file), out)
```
