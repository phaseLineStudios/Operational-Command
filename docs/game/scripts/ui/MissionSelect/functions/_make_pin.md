# MissionSelect::_make_pin Function Reference

*Defined at:* `scripts/ui/MissionSelect.gd` (lines 121–145)</br>
*Belongs to:* [MissionSelect](../../MissionSelect.md)

**Signature**

```gdscript
func _make_pin(m: ScenarioData) -> BaseButton
```

## Description

Builds a pin control.

## Source

```gdscript
func _make_pin(m: ScenarioData) -> BaseButton:
	var title: String = m.title
	if pin_texture:
		var t := TextureButton.new()
		t.texture_normal = pin_texture
		t.expand = true
		t.ignore_texture_size = true
		t.custom_minimum_size = Vector2(pin_size)
		t.focus_mode = Control.FOCUS_NONE
		if show_pin_tooltips:
			t.tooltip_text = title
		return t
	else:
		var b := Button.new()
		b.text = "●"
		b.flat = true
		b.custom_minimum_size = Vector2(pin_size)
		b.focus_mode = Control.FOCUS_NONE
		b.add_theme_font_size_override("font_size", pin_size.y)
		_apply_transparent_button_style(b)
		if show_pin_tooltips:
			b.tooltip_text = title
		return b
```
