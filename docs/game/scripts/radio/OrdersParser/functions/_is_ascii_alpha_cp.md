# OrdersParser::_is_ascii_alpha_cp Function Reference

*Defined at:* `scripts/radio/OrdersParser.gd` (lines 450–453)</br>
*Belongs to:* [OrdersParser](../../OrdersParser.md)

**Signature**

```gdscript
func _is_ascii_alpha_cp(cp: int) -> bool
```

## Description

ASCII alpha test for a code point.

## Source

```gdscript
func _is_ascii_alpha_cp(cp: int) -> bool:
	return (cp >= 65 and cp <= 90) or (cp >= 97 and cp <= 122)
```
