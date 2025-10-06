# AmmoRearmPanel::_add_section_label Function Reference

*Defined at:* `scripts/ui/AmmoRearmPanel.gd` (lines 267–273)</br>
*Belongs to:* [AmmoRearmPanel](../AmmoRearmPanel.md)

**Signature**

```gdscript
func _add_section_label(title: String) -> void
```

## Source

```gdscript
func _add_section_label(title: String) -> void:
	var lab := Label.new()
	lab.text = title
	lab.add_theme_color_override("font_color", Color(1, 1, 1, 0.9))
	_box_ammo.add_child(lab)
```
