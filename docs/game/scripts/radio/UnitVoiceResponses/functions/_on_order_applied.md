# UnitVoiceResponses::_on_order_applied Function Reference

*Defined at:* `scripts/radio/UnitVoiceResponses.gd` (lines 106–133)</br>
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
	if not TTSService or not TTSService.is_ready():
		return

	var order_type := _get_order_type_name(order.get("type", "UNKNOWN"))
	var callsign := str(order.get("callsign", "Unit"))
	var unit_id := str(order.get("unit_id", ""))

	if order_type == "REPORT":
		_handle_report(order, callsign, unit_id)
		return

	if order_type == "FIRE":
		return

	var ack := _get_acknowledgment(order_type)
	if ack.is_empty():
		return

	var response := "%s, %s" % [callsign, ack]

	_current_transmitter = callsign
	transmission_start.emit(callsign)

	TTSService.say(response)
	unit_response.emit(callsign, response)
```
