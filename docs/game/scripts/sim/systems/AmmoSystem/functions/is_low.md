# AmmoSystem::is_low Function Reference

*Defined at:* `scripts/sim/systems/AmmoSystem.gd` (lines 82–91)</br>
*Belongs to:* [AmmoSystem](../../AmmoSystem.md)

**Signature**

```gdscript
func is_low(su: ScenarioUnit, t: String) -> bool
```

## Description

True if current/cap <= low threshold (and > 0).

## Source

```gdscript
func is_low(su: ScenarioUnit, t: String) -> bool:
	if su == null or su.unit == null:
		return false
	var cap := int(su.unit.ammunition.get(t, 0))
	if cap <= 0:
		return false
	var cur := int(su.state_ammunition.get(t, 0))
	return cur > 0 and float(cur) / float(cap) <= su.unit.ammunition_low_threshold
```
