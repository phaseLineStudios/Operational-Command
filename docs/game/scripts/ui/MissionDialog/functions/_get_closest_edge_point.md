# MissionDialog::_get_closest_edge_point Function Reference

*Defined at:* `scripts/ui/MissionDialog.gd` (lines 190–215)</br>
*Belongs to:* [MissionDialog](../../MissionDialog.md)

**Signature**

```gdscript
func _get_closest_edge_point(rect: Rect2, target: Vector2) -> Vector2
```

## Description

Get the closest point on the rectangle edge to a target position

## Source

```gdscript
func _get_closest_edge_point(rect: Rect2, target: Vector2) -> Vector2:
	var center := rect.get_center()

	# If target is inside rect, return center
	if rect.has_point(target):
		return center

	# Calculate intersection with rect edges
	var dx := target.x - center.x
	var dy := target.y - center.y

	if dx == 0.0 and dy == 0.0:
		return center

	# Find which edge the line from center to target intersects first
	var half_w := rect.size.x * 0.5
	var half_h := rect.size.y * 0.5

	# Time to reach each edge
	var t_x: float = INF if dx == 0.0 else half_w / abs(dx)
	var t_y: float = INF if dy == 0.0 else half_h / abs(dy)

	var t: float = min(t_x, t_y)
	return Vector2(center.x + dx * t, center.y + dy * t)
```
