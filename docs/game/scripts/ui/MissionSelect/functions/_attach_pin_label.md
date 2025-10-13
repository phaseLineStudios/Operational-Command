# MissionSelect::_attach_pin_label Function Reference

*Defined at:* `scripts/ui/MissionSelect.gd` (lines 132–172)</br>
*Belongs to:* [MissionSelect](../../MissionSelect.md)

**Signature**

```gdscript
func _attach_pin_label(pin_btn: BaseButton, title: String) -> void
```

## Description

Create and attach a readable label to a pin button.

## Source

```gdscript
func _attach_pin_label(pin_btn: BaseButton, title: String) -> void:
	# Remove old label (if any) to avoid duplicates when rebuilding pins.
	if pin_btn.has_node("PinLabel"):
		pin_btn.get_node("PinLabel").queue_free()

	if not show_pin_labels or title.strip_edges() == "":
		return

	var panel := PanelContainer.new()
	panel.name = "PinLabel"
	panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	panel.z_index = 1
	panel.position = pin_label_offset
	panel.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	panel.size_flags_vertical = Control.SIZE_SHRINK_BEGIN

	var sb := StyleBoxFlat.new()
	sb.bg_color = pin_label_bg_color
	sb.corner_radius_top_left = pin_label_corner_radius
	sb.corner_radius_top_right = pin_label_corner_radius
	sb.corner_radius_bottom_left = pin_label_corner_radius
	sb.corner_radius_bottom_right = pin_label_corner_radius
	sb.content_margin_left = pin_label_padding.x
	sb.content_margin_right = pin_label_padding.x
	sb.content_margin_top = pin_label_padding.y
	sb.content_margin_bottom = pin_label_padding.y
	panel.add_theme_stylebox_override("panel", sb)

	var lab := Label.new()
	lab.text = title
	lab.mouse_filter = Control.MOUSE_FILTER_IGNORE
	lab.autowrap_mode = TextServer.AUTOWRAP_OFF
	lab.clip_text = false
	lab.custom_minimum_size = Vector2.ZERO
	lab.add_theme_font_size_override("font_size", pin_label_font_size)
	lab.add_theme_color_override("font_color", pin_label_text_color)

	panel.add_child(lab)
	pin_btn.add_child(panel)
```
