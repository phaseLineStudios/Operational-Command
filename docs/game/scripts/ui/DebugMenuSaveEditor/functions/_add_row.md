# DebugMenuSaveEditor::_add_row Function Reference

*Defined at:* `scripts/ui/DebugMenuSaveEditor.gd` (lines 160–179)</br>
*Belongs to:* [DebugMenuSaveEditor](../../DebugMenuSaveEditor.md)

**Signature**

```gdscript
func _add_row(label_text: String, value: String, callback: Callable) -> void
```

## Description

Add a text field row to save editor

## Source

```gdscript
func _add_row(label_text: String, value: String, callback: Callable) -> void:
	var label := Label.new()
	label.text = label_text + ":"
	label.custom_minimum_size.x = 150
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	save_editor_content.add_child(label)

	if callback.is_null():
		var value_label := Label.new()
		value_label.text = value
		value_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		save_editor_content.add_child(value_label)
	else:
		var line_edit := LineEdit.new()
		line_edit.text = value
		line_edit.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		line_edit.text_submitted.connect(callback)
		save_editor_content.add_child(line_edit)
```
