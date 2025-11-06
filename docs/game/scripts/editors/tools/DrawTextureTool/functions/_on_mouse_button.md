# DrawTextureTool::_on_mouse_button Function Reference

*Defined at:* `scripts/editors/tools/ScenarioDrawTextureTool.gd` (lines 50–58)</br>
*Belongs to:* [DrawTextureTool](../../DrawTextureTool.md)

**Signature**

```gdscript
func _on_mouse_button(e: InputEventMouseButton) -> bool
```

- **e**: InputEventMouseButton.
- **Return Value**: true if consumed.

## Description

Handle mouse button.

## Source

```gdscript
func _on_mouse_button(e: InputEventMouseButton) -> bool:
	if not texture:
		return false
	if e.button_index == MOUSE_BUTTON_LEFT and e.pressed:
		_place()
		return true
	return false
```
