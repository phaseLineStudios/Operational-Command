# UnitCounter::_counter_to_mil_affiliation Function Reference

*Defined at:* `scripts/sim/UnitCounter.gd` (lines 85–98)</br>
*Belongs to:* [UnitCounter](../../UnitCounter.md)

**Signature**

```gdscript
func _counter_to_mil_affiliation(aff: CounterAffiliation) -> MilSymbol.UnitAffiliation
```

## Description

Convert CounterAffiliation to MilSymbol.UnitAffiliation

## Source

```gdscript
func _counter_to_mil_affiliation(aff: CounterAffiliation) -> MilSymbol.UnitAffiliation:
	match aff:
		CounterAffiliation.PLAYER, CounterAffiliation.FRIEND:
			return MilSymbol.UnitAffiliation.FRIEND
		CounterAffiliation.ENEMY:
			return MilSymbol.UnitAffiliation.ENEMY
		CounterAffiliation.NEUTRAL:
			return MilSymbol.UnitAffiliation.NEUTRAL
		CounterAffiliation.UNKNOWN:
			return MilSymbol.UnitAffiliation.UNKNOWN
		_:
			return MilSymbol.UnitAffiliation.UNKNOWN
```
