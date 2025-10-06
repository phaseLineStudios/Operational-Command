# TerrainHistory::_erase_item_by_id Function Reference

*Defined at:* `scripts/editors/TerrainHistory.gd` (lines 145–153)</br>
*Belongs to:* [TerrainHistory](../TerrainHistory.md)

**Signature**

```gdscript
func _erase_item_by_id(data: TerrainData, array_name: String, id_value) -> void
```

## Description

Remove a single item (by id) from `data[array_name]`, then emit.

## Source

```gdscript
func _erase_item_by_id(data: TerrainData, array_name: String, id_value) -> void:
	var arr: Array = data.get(array_name)
	var idx := _find_index_by_id(arr, id_value)
	if idx >= 0:
		arr.remove_at(idx)
		data.set(array_name, arr)
		_emit_changed(data)
```
