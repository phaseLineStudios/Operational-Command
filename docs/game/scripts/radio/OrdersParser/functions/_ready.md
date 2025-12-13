# OrdersParser::_ready Function Reference

*Defined at:* `scripts/radio/OrdersParser.gd` (lines 38–45)</br>
*Belongs to:* [OrdersParser](../../OrdersParser.md)

**Signature**

```gdscript
func _ready() -> void
```

## Source

```gdscript
func _ready() -> void:
	_tables = NARules.get_parser_tables()
	# Register a couple of common navigation-bias phrases
	register_navigation_bias_phrase("stick to roads", StringName("roads"))
	register_navigation_bias_phrase("proceed cautiously", StringName("cover"))
	register_navigation_bias_phrase("shortest route", StringName("shortest"))
```
