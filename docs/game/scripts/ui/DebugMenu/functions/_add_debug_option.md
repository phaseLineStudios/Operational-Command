# DebugMenu::_add_debug_option Function Reference

*Defined at:* `scripts/ui/DebugMenu.gd` (lines 552–649)</br>
*Belongs to:* [DebugMenu](../../DebugMenu.md)

**Signature**

```gdscript
func _add_debug_option(node: Node, option: Dictionary) -> void
```

## Description

Add a single debug option to the UI

## Source

```gdscript
func _add_debug_option(node: Node, option: Dictionary) -> void:
	if not option.has("name") or not option.has("type"):
		return

	# Add label to first column
	var label := Label.new()
	label.text = option["name"]
	label.custom_minimum_size.x = 200
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER

	# Apply tooltip if available
	var tooltip: String = option.get("tooltip", "")
	if tooltip != "":
		label.tooltip_text = tooltip

	scene_options_container.add_child(label)

	var type: String = option["type"]
	var callback: Callable = option.get("callback", Callable())

	# Add control to second column (will expand to fill)
	var control: Control = null

	match type:
		"bool":
			var checkbox := CheckBox.new()
			checkbox.button_pressed = option.get("value", false)
			if callback.is_valid():
				checkbox.toggled.connect(
					func(pressed: bool):
						if is_instance_valid(node):
							callback.call(pressed)
				)
			control = checkbox

		"int", "float":
			var spinbox := SpinBox.new()
			spinbox.value = option.get("value", 0.0)
			spinbox.min_value = option.get("min", -999999.0)
			spinbox.max_value = option.get("max", 999999.0)
			spinbox.step = option.get("step", 1.0 if type == "int" else 0.1)
			spinbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			if callback.is_valid():
				spinbox.value_changed.connect(
					func(value: float):
						if is_instance_valid(node):
							callback.call(value)
				)
			control = spinbox

		"string":
			var line_edit := LineEdit.new()
			line_edit.text = option.get("value", "")
			line_edit.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			if callback.is_valid():
				line_edit.text_changed.connect(
					func(text: String):
						if is_instance_valid(node):
							callback.call(text)
				)
			control = line_edit

		"enum":
			var option_button := OptionButton.new()
			var options_list: Array = option.get("options", [])
			for opt in options_list:
				option_button.add_item(str(opt))
			var current_value = option.get("value", 0)
			if current_value is int:
				option_button.selected = current_value
			option_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			if callback.is_valid():
				option_button.item_selected.connect(
					func(index: int):
						if is_instance_valid(node):
							callback.call(index)
				)
			control = option_button

		"button":
			var button := Button.new()
			button.text = option.get("button_text", "Execute")
			button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			if callback.is_valid():
				button.pressed.connect(
					func():
						if is_instance_valid(node):
							callback.call()
				)
			control = button

	if control:
		# Apply tooltip to control as well
		if tooltip != "":
			control.tooltip_text = tooltip
		scene_options_container.add_child(control)
```
