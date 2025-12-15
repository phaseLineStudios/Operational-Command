# ScenarioUnit::_kph_to_mps Function Reference

*Defined at:* `scripts/editors/ScenarioUnit.gd` (lines 353–356)</br>
*Belongs to:* [ScenarioUnit](../../ScenarioUnit.md)

**Signature**

```gdscript
func _kph_to_mps(speed_kph: float) -> float
```

## Description

Convert kph to mps

## Source

```gdscript
func _kph_to_mps(speed_kph: float) -> float:
	return max(0.0, speed_kph) * (1000.0 / 3600.0)
```
