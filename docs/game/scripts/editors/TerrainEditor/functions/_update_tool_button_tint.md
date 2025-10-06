# TerrainEditor::_update_tool_button_tint Function Reference

*Defined at:* `scripts/editors/TerrainEditor.gd` (lines 267–274)</br>
*Belongs to:* [TerrainEditor](../TerrainEditor.md)

**Signature**

```gdscript
func _update_tool_button_tint(btn: TextureButton) -> void
```

## Description

Update tool button tint

## Source

```gdscript
func _update_tool_button_tint(btn: TextureButton) -> void:
	var hovered := bool(btn.get_meta("hovered", false))
	if btn.button_pressed or hovered:
		btn.self_modulate = Color(1, 1, 1, 1.0)  # fully visible
	else:
		btn.self_modulate = Color(1, 1, 1, 0.4)  # dimmed idle
```
