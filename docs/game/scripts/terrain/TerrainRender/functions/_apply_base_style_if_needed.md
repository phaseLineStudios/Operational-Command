# TerrainRender::_apply_base_style_if_needed Function Reference

*Defined at:* `scripts/terrain/TerrainRender.gd` (lines 125–133)</br>
*Belongs to:* [TerrainRender](../../TerrainRender.md)

**Signature**

```gdscript
func _apply_base_style_if_needed() -> void
```

## Description

Build base style

## Source

```gdscript
func _apply_base_style_if_needed() -> void:
	if _base_sb == null:
		_base_sb = StyleBoxFlat.new()
	_base_sb.bg_color = base_color
	_base_sb.set_border_width_all(terrain_border_px)
	_base_sb.border_color = terrain_border_color
	base_layer.add_theme_stylebox_override("panel", _base_sb)
```
