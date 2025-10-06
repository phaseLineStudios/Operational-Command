# MapController::_plane_hit_to_map_px Function Reference

*Defined at:* `scripts/core/MapController.gd` (lines 163–176)</br>
*Belongs to:* [MapController](../MapController.md)

**Signature**

```gdscript
func _plane_hit_to_map_px(hit_world: Vector3) -> Variant
```

## Description

Convert a world hit on the plane to map pixels (0..viewport size)

## Source

```gdscript
func _plane_hit_to_map_px(hit_world: Vector3) -> Variant:
	if map == null or _plane == null:
		return null
	var local := map.to_local(hit_world)
	var half_w := _plane.size.x * 0.5
	var half_h := _plane.size.y * 0.5
	if abs(local.x) > half_w or abs(local.z) > half_h:
		return null
	var u := (local.x / (_plane.size.x)) + 0.5
	var v := (local.z / (_plane.size.y)) + 0.5
	var vp := terrain_viewport.size
	return Vector2(clamp(u, 0.0, 1.0) * vp.x, clamp(v, 0.0, 1.0) * vp.y)
```
