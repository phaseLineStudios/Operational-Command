# Settings::linear_to_db Function Reference

*Defined at:* `scripts/ui/Settings.gd` (lines 443–446)</br>
*Belongs to:* [Settings](../../Settings.md)

**Signature**

```gdscript
func linear_to_db(v: float) -> float
```

## Description

Linear→dB helper.

## Source

```gdscript
func linear_to_db(v: float) -> float:
	return -80.0 if v <= 0.0001 else 20.0 * (log(v) / log(10.0))
```
