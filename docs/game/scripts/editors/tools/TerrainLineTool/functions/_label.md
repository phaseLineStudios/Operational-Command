# TerrainLineTool::_label Function Reference

*Defined at:* `scripts/editors/tools/TerrainLineTool.gd` (lines 392–397)</br>
*Belongs to:* [TerrainLineTool](../TerrainLineTool.md)

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
