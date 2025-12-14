# DebugMenu::_build_scene_options_ui Function Reference

*Defined at:* `scripts/ui/DebugMenu.gd` (lines 468–506)</br>
*Belongs to:* [DebugMenu](../../DebugMenu.md)

**Signature**

```gdscript
func _build_scene_options_ui() -> void
```

## Description

Build UI for all discovered scene options

## Source

```gdscript
func _build_scene_options_ui() -> void:
	if _scene_options_discovered.is_empty():
		var label := Label.new()
		label.text = "No debug options found in scene."
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		scene_options_container.columns = 1
		scene_options_container.add_child(label)
		return

	scene_options_container.columns = 2

	for entry in _scene_options_discovered:
		var node: Node = entry["node"]
		var options: Array = entry["options"]

		# Add section separator (spans both columns by adding to both cells)
		var separator1 := HSeparator.new()
		separator1.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		scene_options_container.add_child(separator1)
		var separator2 := HSeparator.new()
		separator2.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		scene_options_container.add_child(separator2)

		# Add section header with node name (spans both columns by adding to both cells)
		var header := Label.new()
		header.text = node.name + " (%s)" % node.get_class()
		header.add_theme_font_size_override("font_size", 14)
		header.add_theme_color_override("font_color", Color.YELLOW)
		scene_options_container.add_child(header)
		# Add empty cell to complete the row
		var spacer := Control.new()
		scene_options_container.add_child(spacer)

		# Add each option
		for option in options:
			_add_debug_option(node, option)
```
