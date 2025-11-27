# AIAgent::intent_defend_begin Function Reference

*Defined at:* `scripts/ai/AIAgent.gd` (lines 167–180)</br>
*Belongs to:* [AIAgent](../../AIAgent.md)

**Signature**

```gdscript
func intent_defend_begin(center_m: Variant, radius: float) -> void
```

## Source

```gdscript
func intent_defend_begin(center_m: Variant, radius: float) -> void:
	var su := _get_su()
	if su == null or _movement == null:
		return
	var center_v3: Vector3
	if typeof(center_m) == TYPE_VECTOR2:
		var v2: Vector2 = center_m
		center_v3 = Vector3(v2.x, 0.0, v2.y)
	else:
		center_v3 = center_m
	if _movement.has_method("request_hold_area"):
		_movement.request_hold_area(center_v3, radius)
```
