# AmmoSystem::is_empty Function Reference

*Defined at:* `scripts/sim/systems/AmmoSystem.gd` (lines 92–95)</br>
*Belongs to:* [AmmoSystem](../../AmmoSystem.md)

**Signature**

```gdscript
func is_empty(u: UnitData, t: String) -> bool
```

## Description

True if current ammo is zero.

## Source

```gdscript
func is_empty(u: UnitData, t: String) -> bool:
	return int(u.state_ammunition.get(t, 0)) <= 0
```
