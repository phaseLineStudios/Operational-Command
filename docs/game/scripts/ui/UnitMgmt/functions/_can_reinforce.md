# UnitMgmt::_can_reinforce Function Reference

*Defined at:* `scripts/ui/UnitMgmt.gd` (lines 166–167)</br>
*Belongs to:* [UnitMgmt](../../UnitMgmt.md)

**Signature**

```gdscript
func _can_reinforce(u: UnitData) -> bool
```

## Description

Test if a unit can be reinforced (this screen cannot reinforce wiped-out units).

## Source

```gdscript
func _can_reinforce(u: UnitData) -> bool:
	return u != null and u.state_strength > 0.0
```
