# UnitCard::_make_drag_preview Function Reference

*Defined at:* `scripts/ui/helpers/UnitCard.gd` (lines 125–173)</br>
*Belongs to:* [UnitCard](../../UnitCard.md)

**Signature**

```gdscript
func _make_drag_preview() -> Control
```

## Description

Build a fixed-size preview that matches the pool layout.

## Source

```gdscript
func _make_drag_preview() -> Control:
	var s := size if (_cached_size == Vector2.ZERO) else _cached_size

	var p := PanelContainer.new()
	p.set_anchors_preset(Control.PRESET_TOP_LEFT)
	p.custom_minimum_size = s
	p.size = s
	p.mouse_filter = Control.MOUSE_FILTER_IGNORE

	var sb := get_theme_stylebox("panel")
	if sb:
		p.add_theme_stylebox_override("panel", sb.duplicate())

	var hb := HBoxContainer.new()
	hb.add_theme_constant_override("separation", 8)
	hb.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hb.mouse_filter = Control.MOUSE_FILTER_IGNORE
	p.add_child(hb)

	var icon := TextureRect.new()
	icon.texture = _icon.texture
	icon.custom_minimum_size = _icon.custom_minimum_size
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	hb.add_child(icon)

	var vb := VBoxContainer.new()
	vb.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	vb.mouse_filter = Control.MOUSE_FILTER_IGNORE
	hb.add_child(vb)

	var name_label := Label.new()
	name_label.text = _name.text
	name_label.clip_text = true
	name_label.autowrap_mode = TextServer.AUTOWRAP_OFF
	name_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	name_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	vb.add_child(name_label)

	var role := Label.new()
	role.text = _role.text
	role.clip_text = true
	role.autowrap_mode = TextServer.AUTOWRAP_OFF
	role.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	role.mouse_filter = Control.MOUSE_FILTER_IGNORE
	vb.add_child(role)

	return p
```
