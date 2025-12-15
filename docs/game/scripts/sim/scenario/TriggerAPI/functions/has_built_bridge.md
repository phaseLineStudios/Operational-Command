# TriggerAPI::has_built_bridge Function Reference

*Defined at:* `scripts/sim/scenario/TriggerAPI.gd` (lines 484–487)</br>
*Belongs to:* [TriggerAPI](../../TriggerAPI.md)

**Signature**

```gdscript
func has_built_bridge() -> bool
```

- **Return Value**: True if at least one bridge has been built.

## Description

Check if any engineers have built a bridge.
Returns true if at least one bridge has been completed.

## Source

```gdscript
func has_built_bridge() -> bool:
	return _bridges_built > 0
```
