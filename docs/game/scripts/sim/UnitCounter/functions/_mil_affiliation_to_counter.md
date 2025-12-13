# UnitCounter::_mil_affiliation_to_counter Function Reference

*Defined at:* `scripts/sim/UnitCounter.gd` (lines 106–119)</br>
*Belongs to:* [UnitCounter](../../UnitCounter.md)

**Signature**

```gdscript
func _mil_affiliation_to_counter(aff: MilSymbol.UnitAffiliation) -> CounterAffiliation
```

## Description

Convert MilSymbol.UnitAffiliation to CounterAffiliation

## Source

```gdscript
func _mil_affiliation_to_counter(aff: MilSymbol.UnitAffiliation) -> CounterAffiliation:
	match aff:
		MilSymbol.UnitAffiliation.FRIEND:
			return CounterAffiliation.PLAYER
		MilSymbol.UnitAffiliation.ENEMY:
			return CounterAffiliation.ENEMY
		MilSymbol.UnitAffiliation.NEUTRAL:
			return CounterAffiliation.NEUTRAL
		MilSymbol.UnitAffiliation.UNKNOWN:
			return CounterAffiliation.UNKNOWN
		_:
			return CounterAffiliation.UNKNOWN
```
