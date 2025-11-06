# SerializeTerrain::_run Function Reference

*Defined at:* `scripts/utils/SerializeTerrain.gd` (lines 14–36)</br>
*Belongs to:* [SerializeTerrain](../../SerializeTerrain.md)

**Signature**

```gdscript
func _run()
```

## Source

```gdscript
func _run():
	print("SerializeTerrain: Starting...")
	print("  Source: %s" % terrain_data_path)
	print("  Export: %s" % export_path)

	var res := ResourceLoader.load(terrain_data_path)
	if not res is TerrainData:
		push_error("SerializeTerrain: Resource is not TerrainData")
		return

	print("SerializeTerrain: Loaded TerrainData successfully")

	var srl := JSON.stringify(res.serialize(), "\t")
	var f := FileAccess.open(export_path, FileAccess.WRITE)
	if f == null:
		push_error("SerializeTerrain: Failed to open export path: %s" % export_path)
		return

	f.store_string(srl)
	f.flush()
	f.close()

	print("SerializeTerrain: Successfully exported to %s" % export_path)
```
