# LabelLayer::apply_style Function Reference

*Defined at:* `scripts/terrain/LabelLayer.gd` (lines 47–63)</br>
*Belongs to:* [LabelLayer](../../LabelLayer.md)

**Signature**

```gdscript
func apply_style(from: Node)
```

## Description

Apply style fields from TerrainRender

## Source

```gdscript
func apply_style(from: Node):
	if from == null:
		return
	if "outline_color" in from:
		outline_color = from.outline_color
	if "outline_size" in from:
		outline_size = from.outline_size
	if "text_color" in from:
		text_color = from.text_color
	if "font" in from:
		font = from.font
	if "antialias" in from:
		antialias = from.antialias
	_draw_dirty = true
	queue_redraw()
```
