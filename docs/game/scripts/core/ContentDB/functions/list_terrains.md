# ContentDB::list_terrains Function Reference

*Defined at:* `scripts/core/ContentDB.gd` (lines 214–226)</br>
*Belongs to:* [ContentDB](../../ContentDB.md)

**Signature**

```gdscript
func list_terrains() -> Array[TerrainData]
```

- **Return Value**: Array of all terrains.

## Description

list all terrains.

## Source

```gdscript
func list_terrains() -> Array[TerrainData]:
	var terrs := get_all_objects("terrains")
	if terrs.is_empty():
		return []

	var out: Array[TerrainData] = []
	for item in terrs:
		var res := TerrainData.deserialize(item)
		if res != null:
			out.append(res)
	return out
```
