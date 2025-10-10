# SimDebugOverlay::_norm_ratio Function Reference

*Defined at:* `scripts/sim/SimDebugOverlay.gd` (lines 307–310)</br>
*Belongs to:* [SimDebugOverlay](../../SimDebugOverlay.md)

**Signature**

```gdscript
func _norm_ratio(v: float, t: float = 100.0) -> float
```

- **v**: Input value (0..1 or 0..t).
- **t**: Maximum when v is in “percent-like” scale (default 100).
- **Return Value**: Ratio clamped to [0, 1].

## Description

Normalize values; treat values >1 as percentages using `t` as max.

## Source

```gdscript
func _norm_ratio(v: float, t: float = 100.0) -> float:
	return clampf(v if v <= 1.0 else (v / t), 0.0, 1.0)
```
