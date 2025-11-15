# UnitVoiceResponses::_on_order_applied Function Reference

*Defined at:* `scripts/radio/UnitVoiceResponses.gd` (lines 98–126)</br>
*Belongs to:* [UnitVoiceResponses](../../UnitVoiceResponses.md)

**Signature**

```gdscript
func _on_order_applied(order: Dictionary) -> void
```

- **order**: Order dictionary from OrdersRouter.

## Description

Handle order applied - generate acknowledgment or report.

## Source

```gdscript
func _on_order_applied(order: Dictionary) -> void:
	if not tts_service or not tts_service.is_ready():
		return

	var order_type := _get_order_type_name(order.get("type", "UNKNOWN"))
	var callsign := str(order.get("callsign", "Unit"))
	var unit_id := str(order.get("unit_id", ""))

	# Handle REPORT orders specially
	if order_type == "REPORT":
		_handle_report(order, callsign, unit_id)
		return

	# Get random acknowledgment for this order type
	var ack := _get_acknowledgment(order_type)
	if ack.is_empty():
		return

	# Format: "Callsign, acknowledgment"
	# Example: "Alpha, moving out."
	var response := "%s, %s" % [callsign, ack]

	# Speak the response
	tts_service.say(response)

	# Emit signal for transcript logging
	unit_response.emit(callsign, response)
```
