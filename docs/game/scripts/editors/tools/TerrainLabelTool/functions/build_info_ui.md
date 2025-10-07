# TerrainLabelTool::build_info_ui Function Reference

*Defined at:* `scripts/editors/tools/TerrainLabelTool.gd` (lines 92–97)</br>
*Belongs to:* [TerrainLabelTool](../../TerrainLabelTool.md)

**Signature**

```gdscript
func build_info_ui(parent: Control) -> void
```

## Source

```gdscript
func build_info_ui(parent: Control) -> void:
	var l := Label.new()
	l.text = "Place text label"
	parent.add_child(l)
```
