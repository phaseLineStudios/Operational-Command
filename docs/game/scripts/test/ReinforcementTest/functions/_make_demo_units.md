# ReinforcementTest::_make_demo_units Function Reference

*Defined at:* `scripts/test/ReinforcementTest.gd` (lines 300–321)</br>
*Belongs to:* [ReinforcementTest](../../ReinforcementTest.md)

**Signature**

```gdscript
func _make_demo_units() -> Array[UnitData]
```

## Description

Demo units (with per-unit threshold to validate badge/status)

## Source

```gdscript
func _make_demo_units() -> Array[UnitData]:
	var a: UnitData = UnitData.new()
	a.id = "ALPHA"
	a.title = "Alpha"
	a.strength = 30
	a.understrength_threshold = 0.8

	var b: UnitData = UnitData.new()
	b.id = "BRAVO"
	b.title = "Bravo"
	b.strength = 30
	b.understrength_threshold = 0.6

	var c: UnitData = UnitData.new()
	c.id = "CHARLIE"
	c.title = "Charlie"
	c.strength = 30
	c.understrength_threshold = 0.9

	return [a, b, c]
```
