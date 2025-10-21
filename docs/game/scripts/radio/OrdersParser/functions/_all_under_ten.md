# OrdersParser::_all_under_ten Function Reference

*Defined at:* `scripts/radio/OrdersParser.gd` (lines 290–297)</br>
*Belongs to:* [OrdersParser](../../OrdersParser.md)

**Signature**

```gdscript
func _all_under_ten(vals: Array) -> bool
```

## Description

True if all numbers in array are 0..9.

## Source

```gdscript
func _all_under_ten(vals: Array) -> bool:
	for v in vals:
		var iv := int(v)
		if iv < 0 or iv > 9:
			return false
	return true
```
