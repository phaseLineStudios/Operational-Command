# SimEvent::make Function Reference

*Defined at:* `scripts/sim/SimEvent.gd` (lines 32–37)</br>
*Belongs to:* [SimEvent](../../SimEvent.md)

**Signature**

```gdscript
func make(make_type: EventType, make_tick: int, make_payload: Dictionary = {}) -> SimEvent
```

## Description

Construct a new event instance.
[param make_type] Event type.
[param make_tick] Simulation tick index.
[param make_payload] Optional payload dictionary.
[return] Newly created [SimEvent].

## Source

```gdscript
static func make(make_type: EventType, make_tick: int, make_payload: Dictionary = {}) -> SimEvent:
	var e := SimEvent.new()
	e.type = make_type
	e.tick = make_tick
	e.payload = make_payload
	return e
```
