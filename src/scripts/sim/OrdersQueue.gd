class_name OrdersQueue
extends RefCounted
## FIFO queue for order intents with validation stubs.
## Keeps raw orders until SimWorld consumes them.

## Emitted when an order is enqueued.
signal order_enqueued(order: Dictionary)
## Emitted when an order is rejected by validation.
signal order_rejected(order: Dictionary, reason: String)

var _q: Array[Dictionary] = []


## Enqueue a single [param order] (Dictionary). Returns true if accepted.
func enqueue(order: Dictionary, units_by_callsign: Dictionary = {}) -> bool:
	var v := validate(order, units_by_callsign)
	if not v.valid:
		emit_signal("order_rejected", order, v.reason)
		return false

	_q.append(v.order)
	emit_signal("order_enqueued", v.order)
	return true


## Enqueue multiple [param orders]. Returns number accepted.
func enqueue_many(orders: Array, units_by_callsign: Dictionary = {}) -> int:
	var ok := 0
	for o in orders:
		if enqueue(o, units_by_callsign):
			ok += 1
	return ok


## Pop up to [param max_count] ready orders.
func pop_many(max_count: int = 8) -> Array[Dictionary]:
	var out: Array[Dictionary] = []
	var n: int = min(max_count, _q.size())
	for i in n:
		out.append(_q.pop_front())
	return out


## Current size.
func size() -> int:
	return _q.size()


## Clear all pending orders.
func clear() -> void:
	_q.clear()


## Basic structural validation + light normalization.
## Returns { valid: bool, reason: String, order: Dictionary }
func validate(order: Dictionary, units_by_callsign: Dictionary = {}) -> Dictionary:
	if typeof(order) != TYPE_DICTIONARY:
		return {"valid": false, "reason": "not_dictionary"}

	var o := order.duplicate(true)
	o["type"] = o.get("type", "UNKNOWN")
	if not o.has("callsign") and not o.has("unit_id"):
		return {"valid": false, "reason": "no_target"}

	if o.has("callsign") and not o.has("unit_id"):
		var cs: String = str(o.get("callsign"))
		if cs in units_by_callsign:
			o["unit_id"] = units_by_callsign[cs]
		print(o["unit_id"])

	match str(o["type"]).to_upper():
		"MOVE":
			if not o.has("pos_m") and not o.has("target_callsign"):
				return {"valid": false, "reason": "move_missing_destination"}
		"CANCEL", "HOLD":
			pass
		_:
			pass
	return {"valid": true, "order": o}
