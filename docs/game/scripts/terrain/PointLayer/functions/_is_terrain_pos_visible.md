# PointLayer::_is_terrain_pos_visible Function Reference

*Defined at:* `scripts/terrain/PointLayer.gd` (lines 214–219)</br>
*Belongs to:* [PointLayer](../../PointLayer.md)

**Signature**

```gdscript
func _is_terrain_pos_visible(pos_local: Vector2) -> bool
```

## Description

Reuse your original visibility test against terrain rect

## Source

```gdscript
func _is_terrain_pos_visible(pos_local: Vector2) -> bool:
	return renderer.is_inside_terrain(
		pos_local + Vector2(renderer.margin_left_px, renderer.margin_top_px)
	)
```
