# TaskConfigDialog::_build_form Function Reference

*Defined at:* `scripts/editors/TaskConfigDialog.gd` (lines 32–121)</br>
*Belongs to:* [TaskConfigDialog](../../TaskConfigDialog.md)

**Signature**

```gdscript
func _build_form() -> void
```

## Source

```gdscript
func _build_form() -> void:
	for c in form.get_children():
		c.queue_free()

	if not instance or not instance.task:
		return
	var t := instance.task
	var params := t.make_default_params() if instance.params.is_empty() else instance.params

	for p in t.get_configurable_props():
		var row := VBoxContainer.new()
		row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		var n := String(p.name)
		var label := Label.new()
		label.text = n.capitalize()
		label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row.add_child(label)

		var w: Control
		match p.type:
			TYPE_BOOL:
				var cb := CheckBox.new()
				cb.button_pressed = bool(params.get(n, t.get(n)))
				w = cb
			TYPE_FLOAT:
				var sb := SpinBox.new()
				sb.value = float(params.get(n, t.get(n)))
				sb.max_value = 1e12
				sb.step = 1.0
				if p.hint == PROPERTY_HINT_RANGE:
					var parts: PackedStringArray = p.hint_string.split(",")
					if parts.size() >= 2:
						sb.min_value = float(parts[0])
						sb.max_value = float(parts[1])
					if parts.size() >= 3:
						sb.step = float(parts[2])
				w = sb
			TYPE_INT:
				var isb := SpinBox.new()
				isb.allow_lesser = true
				isb.allow_greater = true
				isb.value = int(params.get(n, t.get(n)))
				isb.step = 1.0
				if p.hint == PROPERTY_HINT_RANGE:
					var p2: PackedStringArray = p.hint_string.split(",")
					if p2.size() >= 2:
						isb.min_value = int(p2[0])
						isb.max_value = int(p2[1])
				elif p.hint == PROPERTY_HINT_ENUM:
					var ob := OptionButton.new()
					var choices: PackedStringArray = p.hint_string.split(",")
					var cur := int(params.get(n, t.get(n)))
					for i in choices.size():
						ob.add_item(choices[i], i)
					ob.select(clamp(cur, 0, choices.size() - 1))
					w = ob
				if w == null:
					w = isb
			TYPE_STRING:
				var le := LineEdit.new()
				le.text = String(params.get(n, t.get(n)))
				w = le
			TYPE_VECTOR2:
				var cx := HBoxContainer.new()
				var sx := SpinBox.new()
				var sy := SpinBox.new()
				sx.value = (params.get(n, t.get(n)) as Vector2).x
				sy.value = (params.get(n, t.get(n)) as Vector2).y
				sx.step = 1.0
				sy.step = 1.0
				cx.add_child(Label.new())
				cx.get_child(0).text = "X"
				cx.add_child(sx)
				cx.add_child(Label.new())
				cx.get_child(2).text = "Y"
				cx.add_child(sy)
				cx.set_meta("sx", sx)
				cx.set_meta("sy", sy)
				w = cx
			_:
				var lbl := Label.new()
				lbl.text = "(unsupported type)"
				w = lbl

		w.name = n
		w.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row.add_child(w)
		form.add_child(row)
```
