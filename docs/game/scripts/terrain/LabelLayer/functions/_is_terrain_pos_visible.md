# LabelLayer::_is_terrain_pos_visible Function Reference

*Defined at:* `scripts/terrain/LabelLayer.gd` (lines 248–253)</br>
*Belongs to:* [LabelLayer](../../LabelLayer.md)

**Signature**

```gdscript
func _is_terrain_pos_visible(pos_local: Vector2) -> bool
```

## Description

Visibility test against terrain rect (same as other layers)

## Source

```gdscript
func _is_terrain_pos_visible(pos_local: Vector2) -> bool:
	return renderer.is_inside_terrain(
		pos_local + Vector2(renderer.margin_left_px, renderer.margin_top_px)
	)
```
