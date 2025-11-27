# CombatAdapter::set_rules_of_engagement Function Reference

*Defined at:* `scripts/sim/adapters/CombatAdapter.gd` (lines 164–167)</br>
*Belongs to:* [CombatAdapter](../../CombatAdapter.md)

**Signature**

```gdscript
func set_rules_of_engagement(mode: int) -> void
```

## Description

Rules of engagement from AIAgent
0 = HOLD_FIRE, 1 = RETURN_FIRE, 2 = OPEN_FIRE

## Source

```gdscript
func set_rules_of_engagement(mode: int) -> void:
	_roe = mode
```
