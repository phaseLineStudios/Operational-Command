# TerrainHistory::_find_index_by_id Function Reference

*Defined at:* `scripts/editors/TerrainHistory.gd` (lines 178–185)</br>
*Belongs to:* [TerrainHistory](../../TerrainHistory.md)

**Signature**

```gdscript
func _find_index_by_id(arr: Array, id_value) -> int
```

## Description

Find the index of the dictionary in `arr` whose `"id"` equals `id_value`.

## Source

```gdscript
static func _find_index_by_id(arr: Array, id_value) -> int:
	for i in arr.size():
		var it = arr[i]
		if typeof(it) == TYPE_DICTIONARY and it.has("id") and it.id == id_value:
			return i
	return -1
```
