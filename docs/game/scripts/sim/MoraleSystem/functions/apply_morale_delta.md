# MoraleSystem::apply_morale_delta Function Reference

*Defined at:* `scripts/sim/MoraleSystem.gd` (lines 46–50)</br>
*Belongs to:* [MoraleSystem](../../MoraleSystem.md)

**Signature**

```gdscript
func apply_morale_delta(delta: float, source: String = "delta") -> void
```

## Description

changes morale value

## Source

```gdscript
func apply_morale_delta(delta: float, source: String = "delta") -> void:
	if delta != 0:
		set_morale(morale + delta, source)
```
