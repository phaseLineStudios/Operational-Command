# OrdersParser::register_navigation_bias_phrase Function Reference

*Defined at:* `scripts/radio/OrdersParser.gd` (lines 526–532)</br>
*Belongs to:* [OrdersParser](../../OrdersParser.md)

**Signature**

```gdscript
func register_navigation_bias_phrase(_phrase: String, _bias: StringName) -> void
```

## Description

Register navigation bias phrase (placeholder).

## Source

```gdscript
func register_navigation_bias_phrase(_phrase: String, _bias: StringName) -> void:
	var norm := _normalize_phrase(_phrase)
	if norm == "":
		return
	_nav_bias_phrases[norm] = _bias
```
