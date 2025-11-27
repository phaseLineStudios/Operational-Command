# TerrainRender::_calculate_scaled_margins Function Reference

*Defined at:* `scripts/terrain/TerrainRender.gd` (lines 272–297)</br>
*Belongs to:* [TerrainRender](../../TerrainRender.md)

**Signature**

```gdscript
func _calculate_scaled_margins() -> void
```

## Description

Calculate margin sizes and font sizes based on map size and percentages

## Source

```gdscript
func _calculate_scaled_margins() -> void:
	if data == null:
		return

	# Calculate as percentage of the smaller dimension
	var min_dimension: int = min(data.width_m, data.height_m)

	# Apply margins to each side individually
	if margin_top_percent > 0.0:
		margin_top_px = int(round(min_dimension * margin_top_percent))
	if margin_bottom_percent > 0.0:
		margin_bottom_px = int(round(min_dimension * margin_bottom_percent))
	if margin_left_percent > 0.0:
		margin_left_px = int(round(min_dimension * margin_left_percent))
	if margin_right_percent > 0.0:
		margin_right_px = int(round(min_dimension * margin_right_percent))

	# Scale font sizes
	if title_size_percent > 0.0:
		title_size = int(round(min_dimension * title_size_percent))
	if label_size_percent > 0.0:
		label_size = int(round(min_dimension * label_size_percent))
	if contour_label_size_percent > 0.0:
		contour_label_size = int(round(min_dimension * contour_label_size_percent))
```
