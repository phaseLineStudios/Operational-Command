# OrdersParser::_is_ascii_digit_cp Function Reference

*Defined at:* `scripts/radio/OrdersParser.gd` (lines 452–455)</br>
*Belongs to:* [OrdersParser](../../OrdersParser.md)

**Signature**

```gdscript
func _is_ascii_digit_cp(cp: int) -> bool
```

## Description

ASCII digit test for a code point.

## Source

```gdscript
func _is_ascii_digit_cp(cp: int) -> bool:
	return cp >= 48 and cp <= 57
```
