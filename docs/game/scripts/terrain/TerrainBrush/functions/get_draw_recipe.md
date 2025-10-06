# TerrainBrush::get_draw_recipe Function Reference

*Defined at:* `scripts/terrain/TerrainBrush.gd` (lines 113–134)</br>
*Belongs to:* [TerrainBrush](../TerrainBrush.md)

**Signature**

```gdscript
func get_draw_recipe() -> Dictionary
```

## Description

Provide a light-weight draw recipe for the renderer.

## Source

```gdscript
func get_draw_recipe() -> Dictionary:
	return {
		"title": legend_title,
		"type": feature_type,
		"mode": draw_mode,
		"z_index": z_index,
		"stroke":
		{"color": stroke_color, "width_px": stroke_width_px, "dash_px": dash_px, "gap_px": gap_px},
		"fill":
		{
			"color": fill_color,
			"hatch_spacing_px": hatch_spacing_px,
			"hatch_angle_deg": hatch_angle_deg
		},
		"symbol":
		{
			"tex": symbol,
			"spacing_px": symbol_spacing_px,
			"size": symbol_size_m,
			"align": symbol_align
		}
	}
```
