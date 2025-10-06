# TerrainHistory::_apply_item_by_id Function Reference

*Defined at:* `scripts/editors/TerrainHistory.gd` (lines 135–143)</br>
*Belongs to:* [TerrainHistory](../TerrainHistory.md)

**Signature**

```gdscript
func _apply_item_by_id(data: TerrainData, array_name: String, id_value, item: Dictionary) -> void
```

## Description

Replace a single item (by id) in `data[array_name]` with `item`, then emit.

## Source

```gdscript
func _apply_item_by_id(data: TerrainData, array_name: String, id_value, item: Dictionary) -> void:
	var arr: Array = data.get(array_name)
	var idx := _find_index_by_id(arr, id_value)
	if idx >= 0:
		arr[idx] = item
		data.set(array_name, arr)
		_emit_changed(data)
```
