# MovementAdapter::plan_and_start_to_label Function Reference

*Defined at:* `scripts/sim/adapters/MovementAdapter.gd` (lines 132–141)</br>
*Belongs to:* [MovementAdapter](../../MovementAdapter.md)

**Signature**

```gdscript
func plan_and_start_to_label(su: ScenarioUnit, label_text: String) -> bool
```

- **su**: ScenarioUnit to move.
- **label_text**: Label name to resolve.
- **Return Value**: True if the order was accepted (or deferred), else false.

## Description

Plans and starts movement to a map label.

## Source

```gdscript
func plan_and_start_to_label(su: ScenarioUnit, label_text: String) -> bool:
	if su == null:
		return false
	var pos: Variant = _resolve_label_to_pos(label_text, su.position_m)
	if typeof(pos) == TYPE_VECTOR2:
		return plan_and_start(su, pos)
	LogService.warning("label not found: %s" % label_text, "MovementAdapter.gd:88")
	return false
```
