# TerrainData::_ensure_ids Function Reference

*Defined at:* `scripts/data/TerrainData.gd` (lines 460–471)</br>
*Belongs to:* [TerrainData](../../TerrainData.md)

**Signature**

```gdscript
func _ensure_ids(arr: Array, counter_prop: String) -> Array
```

## Description

Ensure IDs are unique

## Source

```gdscript
func _ensure_ids(arr: Array, counter_prop: String) -> Array:
	var out := []
	for it in arr:
		var item: Dictionary = it
		if item is Dictionary:
			if not item.has("id") or int(item.id) <= 0:
				item.id = self.get(counter_prop)
				self.set(counter_prop, int(self.get(counter_prop)) + 1)
		out.append(item)
	return out
```
