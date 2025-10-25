# BriefingDialog::_rebuild_objectives Function Reference

*Defined at:* `scripts/editors/BriefingDialog.gd` (lines 110–154)</br>
*Belongs to:* [BriefingDialog](../../BriefingDialog.md)

**Signature**

```gdscript
func _rebuild_objectives() -> void
```

## Description

Build objective rows: [Title] [Score] [Edit] [Delete]

## Source

```gdscript
func _rebuild_objectives() -> void:
	for c in objectives_vbox.get_children():
		c.queue_free()

	for i in range(working.frag_objectives.size()):
		var o: ScenarioObjectiveData = working.frag_objectives[i]

		var row := HBoxContainer.new()
		row.custom_minimum_size.y = 28

		var t := Label.new()
		t.text = o.title
		t.size_flags_horizontal = Control.SIZE_EXPAND_FILL

		var s := Label.new()
		s.text = str(o.score)
		s.custom_minimum_size.x = 72
		s.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT

		var edit := Button.new()
		edit.text = "Edit"

		var del := Button.new()
		del.text = "Delete"

		var idx := i
		var obj := o
		edit.pressed.connect(func(): objective_dialog.popup_edit(idx, obj))
		del.pressed.connect(
			func():
				var nxt: Array[ScenarioObjectiveData] = []
				for j in range(working.frag_objectives.size()):
					if j != idx:
						nxt.append(working.frag_objectives[j])
				working.frag_objectives = nxt
				_rebuild_objectives()
		)

		row.add_child(t)
		row.add_child(s)
		row.add_child(edit)
		row.add_child(del)
		objectives_vbox.add_child(row)
```
