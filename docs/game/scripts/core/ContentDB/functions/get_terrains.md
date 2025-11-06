# ContentDB::get_terrains Function Reference

*Defined at:* `scripts/core/ContentDB.gd` (lines 203–211)</br>
*Belongs to:* [ContentDB](../../ContentDB.md)

**Signature**

```gdscript
func get_terrains(ids: Array) -> Array[TerrainData]
```

- **ids**: Array of ids to fetch.
- **Return Value**: Array of associated Terrain Data.

## Description

Get multiple terrains by IDs.

## Source

```gdscript
func get_terrains(ids: Array) -> Array[TerrainData]:
	var out: Array[TerrainData] = []
	for raw in ids:
		var s := get_terrain(String(raw))
		if s:
			out.append(s)
	return out
```
