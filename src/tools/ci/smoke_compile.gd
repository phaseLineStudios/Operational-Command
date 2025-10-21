class_name SmokeCompile
extends SceneTree
## CI smoke-compile: load all .gd/.tscn and fail on load/instantiate errors.

## Roots to scan (res:// paths).
@export var roots: PackedStringArray = ["res://"]
## File extensions to include.
@export var include_exts: PackedStringArray = [".gd", ".tscn"]
## Directories to skip (prefix match).
@export var exclude_dirs: PackedStringArray = ["res://.git", "res://.import"]
## Print progress every N files (0 = disabled).
@export var report_every: int = 50


func _initialize() -> void:
	var e := OS.get_environment("SMOKE_EXCLUDE_DIRS")
	if e != "":
		exclude_dirs = PackedStringArray(e.split(";"))
	var r := OS.get_environment("SMOKE_REPORT_EVERY")
	if r != "":
		report_every = int(r)

	var ok := true
	var files := _collect_files()
	var total := files.size()
	print("Smoke-compile: scanning %d files..." % total)

	for i in files.size():
		var p := files[i]
		var res := ResourceLoader.load(p)
		if res == null:
			ok = false
			push_error("Failed to load: %s" % p)
		elif res is PackedScene:
			if not (res as PackedScene).can_instantiate():
				ok = false
				push_error("PackedScene cannot instantiate (invalid state): %s" % p)

		if report_every > 0 and (i + 1 == total or ((i + 1) % report_every) == 0):
			var pct := int(float(i + 1) * 100.0 / float(total))
			print("... %d/%d (%d%%)" % [i + 1, total, pct])

	quit(0 if ok else 1)


## Collect files to compile
func _collect_files() -> PackedStringArray:
	var out := PackedStringArray()
	for dir_root in roots:
		_walk_dir(dir_root, out)
	return out


## Walk directories
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
