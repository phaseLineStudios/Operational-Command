# ScenarioHistory::_find_index_by_id_res Function Reference

*Defined at:* `scripts/editors/ScenarioHistory.gd` (lines 230–237)</br>
*Belongs to:* [ScenarioHistory](../ScenarioHistory.md)

**Signature**

```gdscript
func _find_index_by_id_res(arr: Array, id_prop: String, id_value: String) -> int
```

## Source

```gdscript
static func _find_index_by_id_res(arr: Array, id_prop: String, id_value: String) -> int:
	for i in arr.size():
		var it = arr[i]
		if it is Resource and _has_prop(it, id_prop) and String(it.get(id_prop)) == id_value:
			return i
	return -1
```
