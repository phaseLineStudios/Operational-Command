# SimDebugOverlay::_compute_map_transform Function Reference

*Defined at:* `scripts/sim/SimDebugOverlay.gd` (lines 125–135)</br>
*Belongs to:* [SimDebugOverlay](../../SimDebugOverlay.md)

**Signature**

```gdscript
func _compute_map_transform() -> void
```

## Description

Compute the Base -> Overlay transform so overlay drawing aligns with the map.

## Source

```gdscript
func _compute_map_transform() -> void:
	if _terrain_base == null:
		_map_tf = Transform2D.IDENTITY
		_map_rect = Rect2(Vector2.ZERO, size)
		return
	var base_xform := _terrain_base.get_global_transform_with_canvas()
	var my_xform := get_global_transform_with_canvas()
	_map_tf = my_xform.affine_inverse() * base_xform
	_map_rect = Rect2(_map_tf.origin, _terrain_base.size)
```
