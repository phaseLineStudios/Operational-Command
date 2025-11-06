# EngineerController::_calculate_center Function Reference

*Defined at:* `scripts/sim/systems/EngineerController.gd` (lines 325–333)</br>
*Belongs to:* [EngineerController](../../EngineerController.md)

**Signature**

```gdscript
func _calculate_center(points: PackedVector2Array) -> Vector2
```

## Description

Calculate center point of a polygon or line

## Source

```gdscript
func _calculate_center(points: PackedVector2Array) -> Vector2:
	if points.size() == 0:
		return Vector2.ZERO
	var center := Vector2.ZERO
	for p in points:
		center += p
	return center / points.size()
```
