# OrdersParser::_normalize_phrase Function Reference

*Defined at:* `scripts/radio/OrdersParser.gd` (lines 560–561)</br>
*Belongs to:* [OrdersParser](../../OrdersParser.md)

**Signature**

```gdscript
func _normalize_phrase(p: String) -> String
```

## Source

```gdscript
func _normalize_phrase(p: String) -> String:
	return p.strip_edges().to_lower()
```
