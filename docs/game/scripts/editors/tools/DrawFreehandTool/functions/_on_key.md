# DrawFreehandTool::_on_key Function Reference

*Defined at:* `scripts/editors/tools/ScenarioDrawFreehandTool.gd` (lines 74–80)</br>
*Belongs to:* [DrawFreehandTool](../../DrawFreehandTool.md)

**Signature**

```gdscript
func _on_key(e: InputEventKey) -> bool
```

- **e**: InputEventKey.
- **Return Value**: true if consumed.

## Description

Handle key events. ESC cancels.

## Source

```gdscript
func _on_key(e: InputEventKey) -> bool:
	if e.pressed and e.keycode == KEY_ESCAPE:
		emit_signal("canceled")
		return true
	return false
```
