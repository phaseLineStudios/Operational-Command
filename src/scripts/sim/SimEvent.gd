class_name SimEvent
extends Node
## Lightweight simulation event.

## Types of events emitted by the sim.
enum EventType {
	UNIT_UPDATED,
	CONTACT_REPORTED,
	ENGAGEMENT_RESOLVED,
	RADIO_MESSAGE,
	ORDER_APPLIED,
	ORDER_REJECTED,
	MISSION_STATE_CHANGED
}

## Event type
@export var type: EventType
## Tick index when this event occurred
@export var tick: int = 0
## Payload data (read-only by convention)
@export var payload: Dictionary = {}


## Create a new event with [param type], [param tick], [param payload].
static func make(make_type: EventType, make_tick: int, make_payload: Dictionary = {}) -> SimEvent:
	var e := SimEvent.new()
	e.type = make_type
	e.tick = make_tick
	e.payload = make_payload
	return e
