# TerrainData::_find_by_id Function Reference

*Defined at:* `scripts/data/TerrainData.gd` (lines 472–479)</br>
*Belongs to:* [TerrainData](../../TerrainData.md)

**Signature**

```gdscript
func _find_by_id(arr: Array, id: int) -> int
```

## Description

Find item by ID

## Source

```gdscript
func _find_by_id(arr: Array, id: int) -> int:
	for i in arr.size():
		var it = arr[i]
		if it is Dictionary and it.has("id") and int(it.id) == id:
			return i
	return -1
```
