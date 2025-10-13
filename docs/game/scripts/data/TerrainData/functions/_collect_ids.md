# TerrainData::_collect_ids Function Reference

*Defined at:* `scripts/data/TerrainData.gd` (lines 463–470)</br>
*Belongs to:* [TerrainData](../../TerrainData.md)

**Signature**

```gdscript
func _collect_ids(arr: Array) -> PackedInt32Array
```

## Description

Collect valid IDs

## Source

```gdscript
func _collect_ids(arr: Array) -> PackedInt32Array:
	var ids := PackedInt32Array()
	for it in arr:
		if it is Dictionary and it.has("id"):
			ids.append(int(it.id))
	return ids
```
