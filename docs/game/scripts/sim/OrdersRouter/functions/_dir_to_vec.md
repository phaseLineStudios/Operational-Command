# OrdersRouter::_dir_to_vec Function Reference

*Defined at:* `scripts/sim/OrdersRouter.gd` (lines 445–467)</br>
*Belongs to:* [OrdersRouter](../../OrdersRouter.md)

**Signature**

```gdscript
func _dir_to_vec(dir: String) -> Vector2
```

- **dir**: Direction label (e.g. "NE", "southwest").
- **Return Value**: Vector2 direction (length may be 0 if unknown).

## Description

Convert a cardinal/intercardinal label to a unit vector (meters space).

## Source

```gdscript
func _dir_to_vec(dir: String) -> Vector2:
	var d := dir.to_lower()
	match d:
		"n", "north":
			return Vector2(0, -1)
		"ne", "northeast":
			return Vector2(1, -1)
		"e", "east":
			return Vector2(1, 0)
		"se", "southeast":
			return Vector2(1, 1)
		"s", "south":
			return Vector2(0, 1)
		"sw", "southwest":
			return Vector2(-1, 1)
		"w", "west":
			return Vector2(-1, 0)
		"nw", "northwest":
			return Vector2(-1, -1)
		_:
			return Vector2.ZERO
```
