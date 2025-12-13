# SubtitleEditor::_clear_editor Function Reference

*Defined at:* `scripts/ui/SubtitleEditor.gd` (lines 145–152)</br>
*Belongs to:* [SubtitleEditor](../../SubtitleEditor.md)

**Signature**

```gdscript
func _clear_editor() -> void
```

## Source

```gdscript
func _clear_editor() -> void:
	subtitle_text.text = ""
	start_time_spin.value = 0.0
	end_time_spin.value = 0.0
	_selected_index = -1
	_update_ui_state()
```
