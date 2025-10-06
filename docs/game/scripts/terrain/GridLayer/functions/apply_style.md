# GridLayer::apply_style Function Reference

*Defined at:* `scripts/terrain/GridLayer.gd` (lines 22–35)</br>
*Belongs to:* [GridLayer](../GridLayer.md)

**Signature**

```gdscript
func apply_style(from: Node) -> void
```

## Description

Apply root style

## Source

```gdscript
func apply_style(from: Node) -> void:
	if from == null:
		return
	if "grid_100m_color" in from:
		grid_100m_color = from.grid_100m_color
	if "grid_1km_color" in from:
		grid_1km_color = from.grid_1km_color
	if "grid_line_px" in from:
		grid_line_px = from.grid_line_px
	if "grid_1km_line_px" in from:
		grid_1km_line_px = from.grid_1km_line_px
	mark_dirty()
```
