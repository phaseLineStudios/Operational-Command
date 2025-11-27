# TerrainLineTool::_load_brushes Function Reference

*Defined at:* `scripts/editors/tools/TerrainLineTool.gd` (lines 25–36)</br>
*Belongs to:* [TerrainLineTool](../../TerrainLineTool.md)

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
			if r is TerrainBrush and r.feature_type == TerrainBrush.FeatureType.LINEAR:
				brushes.append(r)
```
