# DebugMenuSaveEditor::_add_row_int Function Reference

*Defined at:* `scripts/ui/DebugMenuSaveEditor.gd` (lines 181–197)</br>
*Belongs to:* [DebugMenuSaveEditor](../../DebugMenuSaveEditor.md)

**Signature**

```gdscript
func _add_row_int(label_text: String, value: int, callback: Callable) -> void
```

## Description

Add an integer field row to save editor

## Source

```gdscript
func _add_row_int(label_text: String, value: int, callback: Callable) -> void:
	var label := Label.new()
	label.text = label_text + ":"
	label.custom_minimum_size.x = 150
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	save_editor_content.add_child(label)

	var spinbox := SpinBox.new()
	spinbox.value = float(value)
	spinbox.min_value = 0.0
	spinbox.max_value = 99999.0
	spinbox.step = 1.0
	spinbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	spinbox.value_changed.connect(callback)
	save_editor_content.add_child(spinbox)
```
