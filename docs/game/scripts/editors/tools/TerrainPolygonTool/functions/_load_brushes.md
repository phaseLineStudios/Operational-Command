# TerrainPolygonTool::_load_brushes Function Reference

*Defined at:* `scripts/editors/tools/TerrainPolygonTool.gd` (lines 26–39)</br>
*Belongs to:* [TerrainPolygonTool](../../TerrainPolygonTool.md)

**Signature**

```gdscript
func _load_brushes() -> void
```

## Source

```gdscript
func _load_brushes() -> void:
	brushes.clear()
	var files := ResourceLoader.list_directory("res://assets/terrain_brushes")
	for file in files:
		var is_dir := file[file.length() - 1] == "/"
		var extension := file.split(".")[-1]
		if not is_dir and extension in ["tres", "res"]:
			var r := ResourceLoader.load("res://assets/terrain_brushes/%s" % file)
			if r is TerrainBrush:
				if r.feature_type != TerrainBrush.FeatureType.AREA:
					continue
				brushes.append(r)
```
