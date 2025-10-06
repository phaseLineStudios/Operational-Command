# AmmoProfile::apply_defaults_if_missing Function Reference

*Defined at:* `scripts/data/AmmoProfile.gd` (lines 16–25)</br>
*Belongs to:* [AmmoProfile](../AmmoProfile.md)

**Signature**

```gdscript
func apply_defaults_if_missing(u: UnitData) -> void
```

## Description

Fill in caps/state/thresholds if the UnitData is missing them.

## Source

```gdscript
func apply_defaults_if_missing(u: UnitData) -> void:
	if u.ammunition.is_empty():
		u.ammunition = default_caps.duplicate(true)
	if u.state_ammunition.is_empty():
		for k in u.ammunition.keys():
			u.state_ammunition[k] = int(u.ammunition[k])
	if u.ammunition_low_threshold <= 0.0:
		u.ammunition_low_threshold = default_low_threshold
	if u.ammunition_critical_threshold <= 0.0:
		u.ammunition_critical_threshold = default_critical_threshold
```
