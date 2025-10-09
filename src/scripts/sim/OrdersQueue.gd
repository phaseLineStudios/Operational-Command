class_name OrdersQueue
extends RefCounted
## FIFO queue for validated orders to be consumed by the sim.
##
## Holds raw/normalized order dictionaries, provides light validation,
## and exposes batch enqueue/dequeue helpers.
## @experimental

## Emitted when an order is accepted into the queue.
signal order_enqueued(order: Dictionary)
## Emitted when validation rejects an order.
signal order_rejected(order: Dictionary, reason: String)

var _q: Array[Dictionary] = []


## Enqueue a single order.
## [param order] Order dictionary (may include "callsign" or "unit_id").
## [param units_by_callsign] Map callsign:String -> unit_id:String used to resolve targets.
## [return] true if accepted, false if rejected.
func enqueue(order: Dictionary, units_by_callsign: Dictionary = {}) -> bool:
	var v := validate(order, units_by_callsign)
	if not v.valid:
		emit_signal("order_rejected", order, v.reason)
		return false

	_q.append(v.order)
	emit_signal("order_enqueued", v.order)
	return true


## Enqueue multiple orders.
## [param orders] Array of order dictionaries.
## [param units_by_callsign] Callsign → unit_id map used to resolve targets.
## [return] Number of orders accepted.
func enqueue_many(orders: Array, units_by_callsign: Dictionary = {}) -> int:
	var ok := 0
	for o in orders:
		if enqueue(o, units_by_callsign):
			ok += 1
	return ok


## Pop up to `max_count` orders from the front of the queue.
## [param max_count] Maximum number of orders to pop (default `8`).
## [return] Array[Dictionary] of popped orders (≤ `max_count`).
func pop_many(max_count: int = 8) -> Array[Dictionary]:
	var out: Array[Dictionary] = []
	var n: int = min(max_count, _q.size())
	for i in n:
		out.append(_q.pop_front())
	return out


## Current queue size.
## [return] Number of pending orders.
func size() -> int:
	return _q.size()


## Clear all pending orders.
func clear() -> void:
	_q.clear()


## Validate and lightly normalize an order.
## Ensures the structure is a Dictionary, resolves `"callsign"` to `"unit_id"`
## when possible, and checks minimal fields per type.
## [param order] Order dictionary to validate.
## [param units_by_callsign] Callsign → unit_id map used to resolve targets.
## [return] Dictionary `{ "valid": bool, "reason": String, "order": Dictionary }`.
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

	match str(o["type"]).to_upper():
		"MOVE":
			if not o.has("pos_m") and not o.has("target_callsign"):
				return {"valid": false, "reason": "move_missing_destination"}
		"CANCEL", "HOLD":
			pass
		_:
			pass
	return {"valid": true, "order": o}
