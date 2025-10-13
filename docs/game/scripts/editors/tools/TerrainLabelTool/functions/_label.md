# TerrainLabelTool::_label Function Reference

*Defined at:* `scripts/editors/tools/TerrainLabelTool.gd` (lines 227–232)</br>
*Belongs to:* [TerrainLabelTool](../../TerrainLabelTool.md)

**Signature**

```gdscript
func _label(t: String) -> Label
```

## Source

```gdscript
func _label(t: String) -> Label:
	var l := Label.new()
	l.text = t
	return l
```
