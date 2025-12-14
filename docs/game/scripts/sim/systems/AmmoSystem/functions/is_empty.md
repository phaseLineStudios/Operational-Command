# AmmoSystem::is_empty Function Reference

*Defined at:* `scripts/sim/systems/AmmoSystem.gd` (lines 104–109)</br>
*Belongs to:* [AmmoSystem](../../AmmoSystem.md)

**Signature**

```gdscript
func is_empty(su: ScenarioUnit, t: String) -> bool
```

## Description

True if current ammo is zero.

## Source

```gdscript
func is_empty(su: ScenarioUnit, t: String) -> bool:
	if su == null:
		return true
	return int(su.state_ammunition.get(t, 0)) <= 0
```
