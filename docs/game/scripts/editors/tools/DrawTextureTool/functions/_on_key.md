# DrawTextureTool::_on_key Function Reference

*Defined at:* `scripts/editors/tools/ScenarioDrawTextureTool.gd` (lines 62–76)</br>
*Belongs to:* [DrawTextureTool](../../DrawTextureTool.md)

**Signature**

```gdscript
func _on_key(e: InputEventKey) -> bool
```

- **e**: InputEventKey|InputEventMouseButton.
- **Return Value**: true if consumed.

## Description

Handle key/wheel: Q/E rotate, MouseWheel scale, R reset.

## Source

```gdscript
func _on_key(e: InputEventKey) -> bool:
	if e.pressed:
		match e.keycode:
			KEY_Q:
				rotation_deg -= 5.0
			KEY_E:
				rotation_deg += 5.0
			KEY_R:
				rotation_deg = 0.0
				scale = 1.0
		request_redraw_overlay.emit()
		return true
	return false
```
