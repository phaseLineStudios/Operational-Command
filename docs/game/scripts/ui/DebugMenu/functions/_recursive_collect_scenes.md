# DebugMenu::_recursive_collect_scenes Function Reference

*Defined at:* `scripts/ui/DebugMenu.gd` (lines 79–91)</br>
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

	for f in DirAccess.get_files_at(path):
		if f.ends_with(".tscn") or f.ends_with(".scn"):
			out.append(path.path_join(f))
	for d in DirAccess.get_directories_at(path):
		if d.begins_with(".git") or d == ".godot" or d == ".import":
			continue
		_recursive_collect_scenes(path.path_join(d), out)
```
