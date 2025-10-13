# FuelTest::_find_button Function Reference

*Defined at:* `scripts/test/FuelTest.gd` (lines 213–220)</br>
*Belongs to:* [FuelTest](../../FuelTest.md)

**Signature**

```gdscript
func _find_button(paths: PackedStringArray) -> Button
```

## Source

```gdscript
func _find_button(paths: PackedStringArray) -> Button:
	for p in paths:
		var n: Node = get_node_or_null(p)
		if n is Button:
			return n as Button
	return null
```
