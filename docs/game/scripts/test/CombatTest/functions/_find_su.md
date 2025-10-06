# CombatTest::_find_su Function Reference

*Defined at:* `scripts/test/CombatTest.gd` (lines 106–114)</br>
*Belongs to:* [CombatTest](../CombatTest.md)

**Signature**

```gdscript
func _find_su(list: Array[ScenarioUnit], key: String) -> ScenarioUnit
```

## Source

```gdscript
func _find_su(list: Array[ScenarioUnit], key: String) -> ScenarioUnit:
	for su in list:
		if su == null:
			continue
		if su.id == key:
			return su
		if su.unit and su.unit.id == key:
			return su
	return null
```
