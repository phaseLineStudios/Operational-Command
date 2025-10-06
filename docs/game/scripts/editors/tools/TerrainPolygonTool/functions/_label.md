# TerrainPolygonTool::_label Function Reference

*Defined at:* `scripts/editors/tools/TerrainPolygonTool.gd` (lines 375–380)</br>
*Belongs to:* [TerrainPolygonTool](../TerrainPolygonTool.md)

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
