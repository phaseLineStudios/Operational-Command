# PathGrid::mix Function Reference

*Defined at:* `scripts/terrain/PathGrid.gd` (lines 900–901)</br>
*Belongs to:* [PathGrid](../../PathGrid.md)

**Signature**

```gdscript
func mix(a: float, b: float, t: float) -> float
```

## Source

```gdscript
static func mix(a: float, b: float, t: float) -> float:
	return a * (1.0 - t) + b * t
```
