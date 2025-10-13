# TerrainHistory Class Reference

*File:* `scripts/editors/TerrainHistory.gd`
*Class name:* `TerrainHistory`
*Inherits:* `Node`

## Synopsis

```gdscript
class_name TerrainHistory
extends Node
```

## Brief

Wrapper around Godot's UndoRedo system

Records actions, exposes helpers for inserting/editing/erasing items in TerrainData

Insert an item dictionary into `data[array_name]`

Edit (replace) an item by its `id_value` in `data[array_name]`

Erase an item by `id_value` from `data[array_name]`

Replace the entire `data[array_name]` with `after`, undo to `before`

Push an elevation patch operation over a `rect`:

Insert `item` into `data[array_name]` at `at_index` (or append if < 0), then emit.

## Public Member Functions

- [`func undo() -> void`](TerrainHistory/functions/undo.md) — undo the last action
- [`func redo() -> void`](TerrainHistory/functions/redo.md) — Redo the last action
- [`func _record_commit(desc: String) -> void`](TerrainHistory/functions/_record_commit.md) — Record a commit to history
- [`func _apply_array(data: TerrainData, array_name: String, value: Array) -> void`](TerrainHistory/functions/_apply_array.md) — Replace `data[array_name]` with `value` and emit change.
- [`func _apply_item_by_id(data: TerrainData, array_name: String, id_value, item: Dictionary) -> void`](TerrainHistory/functions/_apply_item_by_id.md) — Replace a single item (by id) in `data[array_name]` with `item`, then emit.
- [`func _erase_item_by_id(data: TerrainData, array_name: String, id_value) -> void`](TerrainHistory/functions/_erase_item_by_id.md) — Remove a single item (by id) from `data[array_name]`, then emit.
- [`func _apply_elev_block(data: TerrainData, rect: Rect2i, block: PackedFloat32Array) -> void`](TerrainHistory/functions/_apply_elev_block.md) — Apply an elevation block via TerrainData API and emit change.
- [`func _find_index_by_id(arr: Array, id_value) -> int`](TerrainHistory/functions/_find_index_by_id.md) — Find the index of the dictionary in `arr` whose `"id"` equals `id_value`.
- [`func _deep_copy(x)`](TerrainHistory/functions/_deep_copy.md) — Deep copy for dictionaries, arrays, and common packed arrays used in TerrainData.
- [`func _emit_changed(data)`](TerrainHistory/functions/_emit_changed.md) — Emit a generic change notification on TerrainData.

## Public Attributes

- `Array[String] _past`
- `Array[String] _future`
- `Dictionary item_copy`
- `Dictionary before_c`
- `Dictionary after_c`
- `Dictionary item_c`
- `Array arr`

## Signals

- `signal history_changed(past: Array, future: Array)` — Emitted when the history stack changes

## Member Function Documentation

### undo

```gdscript
func undo() -> void
```

undo the last action

### redo

```gdscript
func redo() -> void
```

Redo the last action

### _record_commit

```gdscript
func _record_commit(desc: String) -> void
```

Record a commit to history

### _apply_array

```gdscript
func _apply_array(data: TerrainData, array_name: String, value: Array) -> void
```

Replace `data[array_name]` with `value` and emit change.

### _apply_item_by_id

```gdscript
func _apply_item_by_id(data: TerrainData, array_name: String, id_value, item: Dictionary) -> void
```

Replace a single item (by id) in `data[array_name]` with `item`, then emit.

### _erase_item_by_id

```gdscript
func _erase_item_by_id(data: TerrainData, array_name: String, id_value) -> void
```

Remove a single item (by id) from `data[array_name]`, then emit.

### _apply_elev_block

```gdscript
func _apply_elev_block(data: TerrainData, rect: Rect2i, block: PackedFloat32Array) -> void
```

Apply an elevation block via TerrainData API and emit change.

### _find_index_by_id

```gdscript
func _find_index_by_id(arr: Array, id_value) -> int
```

Find the index of the dictionary in `arr` whose `"id"` equals `id_value`.

### _deep_copy

```gdscript
func _deep_copy(x)
```

Deep copy for dictionaries, arrays, and common packed arrays used in TerrainData.

### _emit_changed

```gdscript
func _emit_changed(data)
```

Emit a generic change notification on TerrainData.

## Member Data Documentation

### _past

```gdscript
var _past: Array[String]
```

### _future

```gdscript
var _future: Array[String]
```

### item_copy

```gdscript
var item_copy: Dictionary
```

### before_c

```gdscript
var before_c: Dictionary
```

### after_c

```gdscript
var after_c: Dictionary
```

### item_c

```gdscript
var item_c: Dictionary
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
