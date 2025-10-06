# TerrainPointTool::_label Function Reference

*Defined at:* `scripts/editors/tools/TerrainPointTool.gd` (lines 268–273)</br>
*Belongs to:* [TerrainPointTool](../TerrainPointTool.md)

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
