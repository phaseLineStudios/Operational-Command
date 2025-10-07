# ScenarioTriggerTool::_label Function Reference

*Defined at:* `scripts/editors/tools/ScenarioTriggerTool.gd` (lines 101–106)</br>
*Belongs to:* [ScenarioTriggerTool](../../ScenarioTriggerTool.md)

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
