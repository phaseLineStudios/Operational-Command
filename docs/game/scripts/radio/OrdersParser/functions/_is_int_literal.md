# OrdersParser::_is_int_literal Function Reference

*Defined at:* `scripts/radio/OrdersParser.gd` (lines 280–289)</br>
*Belongs to:* [OrdersParser](../../OrdersParser.md)

**Signature**

```gdscript
func _is_int_literal(s: String) -> bool
```

## Description

True if s consists only of ASCII digits (uses unicode_at()).

## Source

```gdscript
func _is_int_literal(s: String) -> bool:
	if s.length() == 0:
		return false
	for i in s.length():
		var cp := s.unicode_at(i)
		if not _is_ascii_digit_cp(cp):
			return false
	return true
```
