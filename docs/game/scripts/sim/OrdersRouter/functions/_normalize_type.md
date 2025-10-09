# OrdersRouter::_normalize_type Function Reference

*Defined at:* `scripts/sim/OrdersRouter.gd` (lines 304–313)</br>
*Belongs to:* [OrdersRouter](../../OrdersRouter.md)

**Signature**

```gdscript
func _normalize_type(t: Variant) -> String
```

## Description

Normalize an order type to its string token.
[param t] Enum index or string.
[return] Uppercase type token.

## Source

```gdscript
func _normalize_type(t: Variant) -> String:
	match typeof(t):
		TYPE_INT:
			return _TYPE_NAMES.get(int(t), "UNKNOWN")
		TYPE_STRING:
			return str(t).to_upper()
		_:
			return "UNKNOWN"
```
