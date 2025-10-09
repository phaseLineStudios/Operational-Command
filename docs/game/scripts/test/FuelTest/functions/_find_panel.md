# FuelTest::_find_panel Function Reference

*Defined at:* `scripts/test/FuelTest.gd` (lines 229–236)</br>
*Belongs to:* [FuelTest](../../FuelTest.md)

**Signature**

```gdscript
func _find_panel(paths: PackedStringArray) -> FuelRefuelPanel
```

## Source

```gdscript
func _find_panel(paths: PackedStringArray) -> FuelRefuelPanel:
	for p in paths:
		var n: Node = get_node_or_null(p)
		if n is FuelRefuelPanel:
			return n as FuelRefuelPanel
	return null
```
