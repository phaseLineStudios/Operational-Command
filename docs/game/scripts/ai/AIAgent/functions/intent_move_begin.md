# AIAgent::intent_move_begin Function Reference

*Defined at:* `scripts/ai/AIAgent.gd` (lines 143–159)</br>
*Belongs to:* [AIAgent](../../AIAgent.md)

**Signature**

```gdscript
func intent_move_begin(point_m: Variant) -> void
```

## Description

Begin a move intent using ScenarioUnit + MovementAdapter pathing

## Source

```gdscript
func intent_move_begin(point_m: Variant) -> void:
	var su := _get_su()
	if su == null or _movement == null:
		return
	var dest_m: Vector2 = Vector2.ZERO
	match typeof(point_m):
		TYPE_VECTOR2:
			dest_m = point_m
		TYPE_VECTOR3:
			var v3: Vector3 = point_m
			dest_m = Vector2(v3.x, v3.z)
		_:
			return
	if _movement.has_method("plan_and_start"):
		_movement.plan_and_start(su, dest_m)
```
