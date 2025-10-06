# TerrainPolygonTool::_load_brushes Function Reference

*Defined at:* `scripts/editors/tools/TerrainPolygonTool.gd` (lines 26–38)</br>
*Belongs to:* [TerrainPolygonTool](../TerrainPolygonTool.md)

**Signature**

```gdscript
func _load_brushes() -> void
```

## Source

```gdscript
func _load_brushes() -> void:
	brushes.clear()
	var dir := DirAccess.open("res://assets/terrain_brushes/")
	if dir:
		for f in dir.get_files():
			if f.ends_with(".tres") or f.ends_with(".res"):
				var r := ResourceLoader.load("res://assets/terrain_brushes/%s" % f)
				if r is TerrainBrush:
					if r.feature_type != TerrainBrush.FeatureType.AREA:
						continue
					brushes.append(r)
```
