# TerrainElevationTool::build_info_ui Function Reference

*Defined at:* `scripts/editors/tools/TerrainElevationTool.gd` (lines 90–95)</br>
*Belongs to:* [TerrainElevationTool](../../TerrainElevationTool.md)

**Signature**

```gdscript
func build_info_ui(parent: Control) -> void
```

## Source

```gdscript
func build_info_ui(parent: Control) -> void:
	var l = Label.new()
	l.text = "Edit Terrain Elevation"
	parent.add_child(l)
```
