# MovementAgent::_to_local_from_terrain Function Reference

*Defined at:* `scripts/ai/MovementAgent.gd` (lines 306–310)</br>
*Belongs to:* [MovementAgent](../../MovementAgent.md)

**Signature**

```gdscript
func _to_local_from_terrain(p_m: Vector2) -> Vector2
```

## Description

Convert terrain meters -> this node's local draw space

## Source

```gdscript
func _to_local_from_terrain(p_m: Vector2) -> Vector2:
	if renderer == null:
		return to_local(p_m)
	var screen := renderer.terrain_to_map(p_m)
	return to_local(screen)
```
