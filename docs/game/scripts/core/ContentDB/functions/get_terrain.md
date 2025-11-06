# ContentDB::get_terrain Function Reference

*Defined at:* `scripts/core/ContentDB.gd` (lines 192–199)</br>
*Belongs to:* [ContentDB](../../ContentDB.md)

**Signature**

```gdscript
func get_terrain(id: String) -> TerrainData
```

- **id**: Terrain ID.
- **Return Value**: Associated Terrain Data.

## Description

Terrain helpers.
Get Terrain by ID.

## Source

```gdscript
func get_terrain(id: String) -> TerrainData:
	var d := get_object("terrains", id)
	if d.is_empty():
		push_warning("Terrain not found: %s" % id)
		return null
	return TerrainData.deserialize(d)
```
