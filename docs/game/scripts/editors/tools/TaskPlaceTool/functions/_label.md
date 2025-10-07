# TaskPlaceTool::_label Function Reference

*Defined at:* `scripts/editors/tools/ScenarioTaskTool.gd` (lines 110–115)</br>
*Belongs to:* [TaskPlaceTool](../../TaskPlaceTool.md)

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
