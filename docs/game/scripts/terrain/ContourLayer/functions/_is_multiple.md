# ContourLayer::_is_multiple Function Reference

*Defined at:* `scripts/terrain/ContourLayer.gd` (lines 394–400)</br>
*Belongs to:* [ContourLayer](../ContourLayer.md)

**Signature**

```gdscript
func _is_multiple(value: float, step: float) -> bool
```

## Description

Helper function to check for multiple

## Source

```gdscript
static func _is_multiple(value: float, step: float) -> bool:
	if step <= 0.0:
		return false
	var t := value / step
	return abs(t - round(t)) < 1e-4
```
