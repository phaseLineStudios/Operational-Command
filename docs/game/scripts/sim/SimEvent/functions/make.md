# SimEvent::make Function Reference

*Defined at:* `scripts/sim/SimEvent.gd` (lines 32–37)</br>
*Belongs to:* [SimEvent](../../SimEvent.md)

**Signature**

```gdscript
func make(make_type: EventType, make_tick: int, make_payload: Dictionary = {}) -> SimEvent
```

- **make_type**: Event type.
- **make_tick**: Simulation tick index.
- **make_payload**: Optional payload dictionary.
- **Return Value**: Newly created [SimEvent].

## Description

Construct a new event instance.

## Source

```gdscript
static func make(make_type: EventType, make_tick: int, make_payload: Dictionary = {}) -> SimEvent:
	var e := SimEvent.new()
	e.type = make_type
	e.tick = make_tick
	e.payload = make_payload
	return e
```
