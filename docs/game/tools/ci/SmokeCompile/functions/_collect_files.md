# SmokeCompile::_collect_files Function Reference

*Defined at:* `tools/ci/smoke_compile.gd` (lines 47–53)</br>
*Belongs to:* [SmokeCompile](../../SmokeCompile.md)

**Signature**

```gdscript
func _collect_files() -> PackedStringArray
```

## Description

Collect files to compile

## Source

```gdscript
func _collect_files() -> PackedStringArray:
	var out := PackedStringArray()
	for dir_root in roots:
		_walk_dir(dir_root, out)
	return out
```
