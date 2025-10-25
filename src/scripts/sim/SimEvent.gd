class_name SimEvent
extends Node
## Lightweight simulation event container.
##
## @brief Carries typed sim notifications (unit updates, contacts, orders, etc.)
## with a tick timestamp and an arbitrary payload dictionary.

## Types of events emitted by the simulation.
enum EventType {
	UNIT_UPDATED,
	CONTACT_REPORTED,
	ENGAGEMENT_RESOLVED,
	RADIO_MESSAGE,
	ORDER_APPLIED,
	ORDER_REJECTED,
	MISSION_STATE_CHANGED
}

## Event type token.
@export var type: EventType
## Simulation tick index when this event occurred.
@export var tick: int = 0
## Arbitrary payload data (treat as read-only by convention).
@export var payload: Dictionary = {}


## Construct a new event instance.
## [param make_type] Event type.
## [param make_tick] Simulation tick index.
## [param make_payload] Optional payload dictionary.
## [return] Newly created [SimEvent].
static func make(make_type: EventType, make_tick: int, make_payload: Dictionary = {}) -> SimEvent:
	var e := SimEvent.new()
	e.type = make_type
	e.tick = make_tick
	e.payload = make_payload
	return e
