# UnitMgmt::_can_reinforce Function Reference

*Defined at:* `scripts/ui/UnitMgmt.gd` (lines 176–178)</br>
*Belongs to:* [UnitMgmt](../../UnitMgmt.md)

**Signature**

```gdscript
func _can_reinforce(uid: String) -> bool
```

## Description

Test if a unit can be reinforced (this screen cannot reinforce wiped-out units).

## Source

```gdscript
func _can_reinforce(uid: String) -> bool:
	var cur_strength: float = _unit_strength.get(uid, 0.0)
	return cur_strength > 0.0
```
