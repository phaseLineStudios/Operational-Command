# AmmoProfile::serialize Function Reference

*Defined at:* `scripts/data/AmmoProfile.gd` (lines 29–36)</br>
*Belongs to:* [AmmoProfile](../../AmmoProfile.md)

**Signature**

```gdscript
func serialize() -> Dictionary
```

## Description

Serialize into JSON

## Source

```gdscript
func serialize() -> Dictionary:
	return {
		"default_caps": default_caps,
		"default_low_threshold": default_low_threshold,
		"default_critical_threshold": default_critical_threshold
	}
```
