# FuelTest::_find_label Function Reference

*Defined at:* `scripts/test/FuelTest.gd` (lines 221–228)</br>
*Belongs to:* [FuelTest](../../FuelTest.md)

**Signature**

```gdscript
func _find_label(paths: PackedStringArray) -> Label
```

## Source

```gdscript
func _find_label(paths: PackedStringArray) -> Label:
	for p in paths:
		var n: Node = get_node_or_null(p)
		if n is Label:
			return n as Label
	return null
```
