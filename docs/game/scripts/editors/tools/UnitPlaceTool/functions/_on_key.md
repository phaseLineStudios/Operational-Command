# UnitPlaceTool::_on_key Function Reference

*Defined at:* `scripts/editors/tools/ScenarioUnitTool.gd` (lines 77–85)</br>
*Belongs to:* [UnitPlaceTool](../UnitPlaceTool.md)

**Signature**

```gdscript
func _on_key(e: InputEventKey) -> bool
```

## Source

```gdscript
func _on_key(e: InputEventKey) -> bool:
	if not e.pressed:
		return false
	if e.keycode == KEY_ESCAPE:
		emit_signal("canceled")
		return true
	return false
```
