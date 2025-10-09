# MovementAdapter::plan_and_start_any Function Reference

*Defined at:* `scripts/sim/adapters/MovementAdapter.gd` (lines 147–162)</br>
*Belongs to:* [MovementAdapter](../../MovementAdapter.md)

**Signature**

```gdscript
func plan_and_start_any(su: ScenarioUnit, dest: Variant) -> bool
```

## Description

Plans and starts movement to either a Vector2 destination or a label.
Also accepts {x,y} or {pos: Vector2} dictionaries.
[param su] ScenarioUnit to move.
[param dest] Vector2 | String | Dictionary destination.
[return] True if the order was accepted (or deferred), else false.

## Source

```gdscript
func plan_and_start_any(su: ScenarioUnit, dest: Variant) -> bool:
	match typeof(dest):
		TYPE_VECTOR2:
			return plan_and_start(su, dest)
		TYPE_STRING:
			return plan_and_start_to_label(su, dest)
		TYPE_DICTIONARY:
			if dest.has("x") and dest.has("y"):
				return plan_and_start(su, Vector2(dest["x"], dest["y"]))
			if dest.has("pos"):
				var p: Vector2 = dest["pos"]
				if typeof(p) == TYPE_VECTOR2:
					return plan_and_start(su, p)
	return false
```
