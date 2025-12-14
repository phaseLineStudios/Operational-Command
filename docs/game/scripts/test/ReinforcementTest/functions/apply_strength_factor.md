# ReinforcementTest::apply_strength_factor Function Reference

*Defined at:* `scripts/test/ReinforcementTest.gd` (lines 177–182)</br>
*Belongs to:* [ReinforcementTest](../../ReinforcementTest.md)

**Signature**

```gdscript
func apply_strength_factor(f: float) -> void
```

## Source

```gdscript
func apply_strength_factor(f: float) -> void:
	strength_factor = f
	if f <= 0.0:
		count = 0
	else:
		count = max(1, int(round(base_count * f)))
```
