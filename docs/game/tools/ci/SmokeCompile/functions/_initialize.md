# SmokeCompile::_initialize Function Reference

*Defined at:* `tools/ci/smoke_compile.gd` (lines 15–45)</br>
*Belongs to:* [SmokeCompile](../SmokeCompile.md)

**Signature**

```gdscript
func _initialize() -> void
```

## Source

```gdscript
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
```
