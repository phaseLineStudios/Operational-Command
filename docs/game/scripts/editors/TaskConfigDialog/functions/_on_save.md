# TaskConfigDialog::_on_save Function Reference

*Defined at:* `scripts/editors/TaskConfigDialog.gd` (lines 122–154)</br>
*Belongs to:* [TaskConfigDialog](../TaskConfigDialog.md)

**Signature**

```gdscript
func _on_save() -> void
```

## Source

```gdscript
func _on_save() -> void:
	if not instance or not instance.task:
		return

	var params := {}
	for row in form.get_children():
		var w := row.get_child(1)
		var key := w.name
		if w is CheckBox:
			params[key] = (w as CheckBox).button_pressed
		elif w is SpinBox:
			params[key] = (w as SpinBox).value
		elif w is LineEdit:
			params[key] = (w as LineEdit).text
		elif w is HBoxContainer and w.has_meta("sx"):
			params[key] = Vector2(w.get_meta("sx").value, w.get_meta("sy").value)
		elif w is OptionButton:
			params[key] = (w as OptionButton).get_selected_id()

	var after := instance.duplicate(true)
	after.params = params

	if editor and editor.history:
		editor.history.push_res_edit_by_id(
			editor.ctx.data, "tasks", "id", String(instance.id), _before, after, "Edit Task"
		)
	else:
		instance.params = params

	emit_signal("saved", instance)
	visible = false
	if editor:
		editor.ctx.request_overlay_redraw()
```
