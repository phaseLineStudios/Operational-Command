# MilSymbolRenderer::_draw Function Reference

*Defined at:* `scripts/utils/unit_symbols/MilSymbolRenderer.gd` (lines 54–84)</br>
*Belongs to:* [MilSymbolRenderer](../../MilSymbolRenderer.md)

**Signature**

```gdscript
func _draw() -> void
```

## Description

Draw the complete symbol

## Source

```gdscript
func _draw() -> void:
	if config == null:
		return

	# Apply scale transformation
	var transform_mat := Transform2D()
	transform_mat = transform_mat.scaled(Vector2(scale_factor, scale_factor))

	# Draw with transformation
	draw_set_transform_matrix(transform_mat)

	# Draw frame
	if config.framed:
		_draw_frame()

	# Draw icon
	if config.show_icon:
		_draw_icon()

	# Draw size/echelon indicator
	if unit_size_text != "":
		_draw_size_indicator()

	# Draw unique designation
	if unique_designation != "":
		_draw_unique_designation()

	# Reset transform
	draw_set_transform_matrix(Transform2D())
```
