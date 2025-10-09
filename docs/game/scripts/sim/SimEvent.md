# SimEvent Class Reference

*File:* `scripts/sim/SimEvent.gd`
*Class name:* `SimEvent`
*Inherits:* `Node`

## Synopsis

```gdscript
class_name SimEvent
extends Node
```

## Brief

Lightweight simulation event container.

## Detailed Description

@brief Carries typed sim notifications (unit updates, contacts, orders, etc.)
with a tick timestamp and an arbitrary payload dictionary.

Types of events emitted by the simulation.

Event type token.

## Public Member Functions

- [`func make(make_type: EventType, make_tick: int, make_payload: Dictionary = {}) -> SimEvent`](SimEvent/functions/make.md) — Construct a new event instance.

## Public Attributes

- `EventType type`
- `int tick` — Simulation tick index when this event occurred.
- `Dictionary payload` — Arbitrary payload data (treat as read-only by convention).

## Member Function Documentation

### make

```gdscript
func make(make_type: EventType, make_tick: int, make_payload: Dictionary = {}) -> SimEvent
```

Construct a new event instance.
[param make_type] Event type.
[param make_tick] Simulation tick index.
[param make_payload] Optional payload dictionary.
[return] Newly created [SimEvent].

## Member Data Documentation

### type

```gdscript
var type: EventType
```

### tick

```gdscript
var tick: int
```

Simulation tick index when this event occurred.

### payload

```gdscript
var payload: Dictionary
```

Arbitrary payload data (treat as read-only by convention).
