# AmmoProfile::apply_defaults_if_missing Function Reference

*Defined at:* `scripts/data/AmmoProfile.gd` (lines 16–27)</br>
*Belongs to:* [AmmoProfile](../../AmmoProfile.md)

**Signature**

```gdscript
func apply_defaults_if_missing(su: ScenarioUnit) -> void
```

## Description

Fill in caps/state/thresholds if the ScenarioUnit is missing them.

## Source

```gdscript
func apply_defaults_if_missing(su: ScenarioUnit) -> void:
	if su.unit.ammunition.is_empty():
		su.unit.ammunition = default_caps.duplicate(true)
	if su.state_ammunition.is_empty():
		for k in su.unit.ammunition.keys():
			su.state_ammunition[k] = int(su.unit.ammunition[k])
	if su.unit.ammunition_low_threshold <= 0.0:
		su.unit.ammunition_low_threshold = default_low_threshold
	if su.unit.ammunition_critical_threshold <= 0.0:
		su.unit.ammunition_critical_threshold = default_critical_threshold
```
