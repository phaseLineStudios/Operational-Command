# ScenarioUnit::is_dead Function Reference

*Defined at:* `scripts/editors/ScenarioUnit.gd` (lines 61–64)</br>
*Belongs to:* [ScenarioUnit](../../ScenarioUnit.md)

**Signature**

```gdscript
func is_dead() -> bool
```

- **Return Value**: True if unit is destroyed.

## Description

Check if unit is dead.

## Source

```gdscript
func is_dead() -> bool:
	return float(unit.state_strength / unit.strength) <= 0.0
```
