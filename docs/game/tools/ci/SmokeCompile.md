# SmokeCompile Class Reference

*File:* `tools/ci/smoke_compile.gd`
*Class name:* `SmokeCompile`
*Inherits:* `SceneTree`

## Synopsis

```gdscript
class_name SmokeCompile
extends SceneTree
```

## Brief

CI smoke-compile: load all .gd/.tscn and fail on load/instantiate errors.

## Public Member Functions

- [`func _initialize() -> void`](SmokeCompile/functions/_initialize.md)
- [`func _collect_files() -> PackedStringArray`](SmokeCompile/functions/_collect_files.md) — Collect files to compile
- [`func _walk_dir(dir_path: String, out: PackedStringArray) -> void`](SmokeCompile/functions/_walk_dir.md) — Walk directories

## Public Attributes

- `PackedStringArray roots` — Roots to scan (res:// paths).
- `PackedStringArray include_exts` — File extensions to include.
- `PackedStringArray exclude_dirs` — Directories to skip (prefix match).
- `int report_every` — Print progress every N files (0 = disabled).

## Member Function Documentation

### _initialize

```gdscript
func _initialize() -> void
```

### _collect_files

```gdscript
func _collect_files() -> PackedStringArray
```

Collect files to compile

### _walk_dir

```gdscript
func _walk_dir(dir_path: String, out: PackedStringArray) -> void
```

Walk directories

## Member Data Documentation

### roots

```gdscript
var roots: PackedStringArray
```

Decorators: `@export`

Roots to scan (res:// paths).

### include_exts

```gdscript
var include_exts: PackedStringArray
```

Decorators: `@export`

File extensions to include.

### exclude_dirs

```gdscript
var exclude_dirs: PackedStringArray
```

Decorators: `@export`

Directories to skip (prefix match).

### report_every

```gdscript
var report_every: int
```

Decorators: `@export`

Print progress every N files (0 = disabled).
