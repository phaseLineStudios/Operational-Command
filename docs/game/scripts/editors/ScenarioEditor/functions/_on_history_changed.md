# ScenarioEditor::_on_history_changed Function Reference

*Defined at:* `scripts/editors/ScenarioEditor.gd` (lines 436–461)</br>
*Belongs to:* [ScenarioEditor](../../ScenarioEditor.md)

**Signature**

```gdscript
func _on_history_changed(past: Array, future: Array) -> void
```

## Description

Rebuild history side panel from UndoRedo stacks

## Source

```gdscript
func _on_history_changed(past: Array, future: Array) -> void:
	for n in history_list.get_children():
		n.queue_free()
	for i in range(past.size()):
		var row := HBoxContainer.new()
		var txt := Label.new()
		txt.text = str(past[i])
		if i == past.size() - 1:
			txt.add_theme_color_override("font_color", Color(1, 1, 1))
			txt.add_theme_font_size_override("font_size", 14)
		row.add_child(txt)
		history_list.add_child(row)
	for i in range(future.size() - 1, -1, -1):
		var row2 := HBoxContainer.new()
		var arrow := Label.new()
		arrow.text = "↻ "
		var txt2 := Label.new()
		txt2.text = str(future[i])
		txt2.add_theme_color_override("font_color", Color(0.8, 0.8, 0.8))
		row2.add_child(arrow)
		row2.add_child(txt2)
		history_list.add_child(row2)
	units._refresh(ctx)
	ctx.request_overlay_redraw()
```
