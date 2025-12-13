# SubtitleEditor::_update_ui_state Function Reference

*Defined at:* `scripts/ui/SubtitleEditor.gd` (lines 153–158)</br>
*Belongs to:* [SubtitleEditor](../../SubtitleEditor.md)

**Signature**

```gdscript
func _update_ui_state() -> void
```

## Source

```gdscript
func _update_ui_state() -> void:
	var has_selection := _selected_index >= 0
	update_btn.disabled = not has_selection
	delete_btn.disabled = not has_selection
```
