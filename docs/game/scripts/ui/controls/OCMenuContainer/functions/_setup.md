# OCMenuContainer::_setup Function Reference

*Defined at:* `scripts/ui/controls/OcMenuContainer.gd` (lines 84–93)</br>
*Belongs to:* [OCMenuContainer](../../OCMenuContainer.md)

**Signature**

```gdscript
func _setup()
```

## Source

```gdscript
func _setup():
	var sb := get_theme_stylebox("panel")
	sb.bg_color = Color(0.067, 0.082, 0.098)
	sb.content_margin_left = padding.x + inner_padding.x
	sb.content_margin_top = padding.y + inner_padding.y
	sb.content_margin_right = padding.z + inner_padding.z
	sb.content_margin_bottom = padding.w + inner_padding.w
	add_theme_stylebox_override("panel", sb)
```
