# UnitPlaceTool::_label Function Reference

*Defined at:* `scripts/editors/tools/ScenarioUnitTool.gd` (lines 115–120)</br>
*Belongs to:* [UnitPlaceTool](../../UnitPlaceTool.md)

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
