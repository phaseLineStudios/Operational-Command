# OrdersParser::register_custom_command Function Reference

*Defined at:* `scripts/radio/OrdersParser.gd` (lines 65–71)</br>
*Belongs to:* [OrdersParser](../../OrdersParser.md)

**Signature**

```gdscript
func register_custom_command(keyword: String, metadata: Dictionary = {}) -> void
```

- **keyword**: The keyword/phrase to match (e.g., "fire mission").
- **metadata**: Optional metadata dict to attach to the CUSTOM order

## Description

Register a custom command keyword for this mission.
When the keyword is detected in voice input, generates a
CUSTOM order instead of standard parsing.
  
  

**Called automatically by SimWorld._init_custom_commands() during mission init.**
  
  

The generated order dictionary will contain:
  
- `type: OrderType.CUSTOM`
  
- `custom_keyword: String` - The matched keyword
  
- `custom_full_text: String` - Full radio text
  
- `custom_metadata: Dictionary` - Metadata passed here
  
- `raw: PackedStringArray` - Tokenized input
Case-insensitive substring match.
(e.g., trigger_id, route_as_order).

## Source

```gdscript
func register_custom_command(keyword: String, metadata: Dictionary = {}) -> void:
	var normalized := keyword.to_lower().strip_edges()
	if normalized != "":
		_custom_commands[normalized] = metadata
		LogService.info("Registered custom command: %s" % keyword, "OrdersParser.gd")
```
