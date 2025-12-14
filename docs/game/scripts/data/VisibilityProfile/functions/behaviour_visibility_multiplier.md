# VisibilityProfile::behaviour_visibility_multiplier Function Reference

*Defined at:* `scripts/data/VisibilityProfile.gd` (lines 72–85)</br>
*Belongs to:* [VisibilityProfile](../../VisibilityProfile.md)

**Signature**

```gdscript
func behaviour_visibility_multiplier(behaviour: int) -> float
```

## Description

Optional helper to apply behaviour-based modifiers.

## Source

```gdscript
func behaviour_visibility_multiplier(behaviour: int) -> float:
	match behaviour:
		0:  # CARELESS
			return 1.1
		1:  # SAFE
			return 1.0
		2:  # AWARE
			return 0.9
		3:  # COMBAT
			return 0.85
		4:  # STEALTH
			return 0.7
		_:
			return 1.0
```
