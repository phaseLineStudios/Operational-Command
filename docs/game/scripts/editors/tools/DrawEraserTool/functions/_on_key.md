# DrawEraserTool::_on_key Function Reference

*Defined at:* `scripts/editors/tools/ScenarioDrawEraserTool.gd` (lines 52–58)</br>
*Belongs to:* [DrawEraserTool](../../DrawEraserTool.md)

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
