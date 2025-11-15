# CombatController::set_debug_enabled Function Reference

*Defined at:* `scripts/sim/Combat.gd` (lines 455–457)</br>
*Belongs to:* [CombatController](../../CombatController.md)

**Signature**

```gdscript
func set_debug_enabled(v: bool) -> void
```

## Description

Toggle debug at runtime

## Source

```gdscript
func set_debug_enabled(v: bool) -> void:
	debug_enabled = v
	_set_debug_rate()
```
