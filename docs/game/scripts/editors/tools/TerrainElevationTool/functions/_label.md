# TerrainElevationTool::_label Function Reference

*Defined at:* `scripts/editors/tools/TerrainElevationTool.gd` (lines 101–106)</br>
*Belongs to:* [TerrainElevationTool](../TerrainElevationTool.md)

**Signature**

```gdscript
func _label(t: String) -> Label
```

## Description

Helper function to create a new label

## Source

```gdscript
func _label(t: String) -> Label:
	var l := Label.new()
	l.text = t
	return l
```
