# UnitCounter::_get_base_color Function Reference

*Defined at:* `scripts/sim/UnitCounter.gd` (lines 120–133)</br>
*Belongs to:* [UnitCounter](../../UnitCounter.md)

**Signature**

```gdscript
func _get_base_color() -> Color
```

## Source

```gdscript
func _get_base_color() -> Color:
	match affiliation:
		CounterAffiliation.PLAYER:
			return Color(0.612, 0.682, 0.722)
		CounterAffiliation.FRIEND:
			return Color(0.647, 0.718, 0.89)
		CounterAffiliation.ENEMY:
			return Color(0.898, 0.212, 0.224)
		CounterAffiliation.NEUTRAL:
			return Color(0.667, 1.0, 0.667, 1.0)
		CounterAffiliation.UNKNOWN:
			return Color(1.0, 1.0, 0.502, 1.0)
		_:
			return Color(1.0, 1.0, 1.0)
```
