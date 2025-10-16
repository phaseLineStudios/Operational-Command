# ScenarioHistory Class Reference

*File:* `scripts/editors/ScenarioHistory.gd`
*Class name:* `ScenarioHistory`
*Inherits:* `Node`

## Synopsis

```gdscript
class_name ScenarioHistory
extends Node
```

## Brief

Wrapper around Godot's UndoRedo for ScenarioData edits.

## Detailed Description

Records actions, supports inserting/removing/replacing resource items in arrays.
moving entities by id, and multi-array atomic changes.

Insert/replace a Resource in data[array_name] by unique id field (e.g. "id" or "key")

Replace item by id with 'after' Resource (undo to 'before')

Erase item by id (undo reinserts the provided backup at original_index, or auto)

Replace entire array (atomic). Provide deep copies of before/after

Move entity (unit/slot/task/trigger) by id. 'ent_type' is "unit"/"slot"/"task"/"trigger"

Set a property on a Resource with undo/redo (emits changed).

Set entity world position by id

## Public Member Functions

- [`func undo() -> void`](ScenarioHistory/functions/undo.md) — Undo last action
- [`func redo() -> void`](ScenarioHistory/functions/redo.md) — Redo next action
- [`func _record_commit(desc: String) -> void`](ScenarioHistory/functions/_record_commit.md)
- [`func push_multi_replace(data: Resource, changes: Array, desc: String) -> void`](ScenarioHistory/functions/push_multi_replace.md) — Replace multiple arrays atomically.
- [`func _apply_array(data: Resource, array_name: String, value: Array) -> void`](ScenarioHistory/functions/_apply_array.md)
- [`func _get_id(res: Resource) -> String`](ScenarioHistory/functions/_get_id.md) — Get id/key from a Resource
- [`func _find_index_by_id_res(arr: Array, id_prop: String, id_value: String) -> int`](ScenarioHistory/functions/_find_index_by_id_res.md)
- [`func _dup_res(r)`](ScenarioHistory/functions/_dup_res.md)
- [`func _deep_copy_array_res(arr: Array) -> Array`](ScenarioHistory/functions/_deep_copy_array_res.md)
- [`func _has_prop(o: Object, p_name: String) -> bool`](ScenarioHistory/functions/_has_prop.md) — Does an Object expose a property with this name
- [`func _emit_changed(data)`](ScenarioHistory/functions/_emit_changed.md)

## Public Attributes

- `Array[String] _past`
- `Array[String] _future`
- `Resource res_copy`
- `Variant b`
- `Variant a`
- `Array arr`

## Signals

- `signal history_changed(past: Array, future: Array)` — Emitted when the history stack changes

## Member Function Documentation

### undo

```gdscript
func undo() -> void
```

Undo last action

### redo

```gdscript
func redo() -> void
```

Redo next action

### _record_commit

```gdscript
func _record_commit(desc: String) -> void
```

### push_multi_replace

```gdscript
func push_multi_replace(data: Resource, changes: Array, desc: String) -> void
```

Replace multiple arrays atomically. changes = [{prop:String, before:Array, after:Array}, ...]

### _apply_array

```gdscript
func _apply_array(data: Resource, array_name: String, value: Array) -> void
```

### _get_id

```gdscript
func _get_id(res: Resource) -> String
```

Get id/key from a Resource

### _find_index_by_id_res

```gdscript
func _find_index_by_id_res(arr: Array, id_prop: String, id_value: String) -> int
```

### _dup_res

```gdscript
func _dup_res(r)
```

### _deep_copy_array_res

```gdscript
func _deep_copy_array_res(arr: Array) -> Array
```

### _has_prop

```gdscript
func _has_prop(o: Object, p_name: String) -> bool
```

Does an Object expose a property with this name

### _emit_changed

```gdscript
func _emit_changed(data)
```

## Member Data Documentation

### _past

```gdscript
var _past: Array[String]
```

### _future

```gdscript
var _future: Array[String]
```

### res_copy

```gdscript
var res_copy: Resource
```

### b

```gdscript
var b: Variant
```

### a

```gdscript
var a: Variant
```

### arr

```gdscript
var arr: Array
```

## Signal Documentation

### history_changed

```gdscript
signal history_changed(past: Array, future: Array)
```

Emitted when the history stack changes
