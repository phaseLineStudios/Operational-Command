# UnitAutoResponses::_event_name_to_enum Function Reference

*Defined at:* `scripts/radio/UnitAutoResponses.gd` (lines 171–227)</br>
*Belongs to:* [UnitAutoResponses](../../UnitAutoResponses.md)

**Signature**

```gdscript
func _event_name_to_enum(event_name: String) -> int
```

- **name**: Event name string (e.g., "MOVEMENT_STARTED").
- **Return Value**: EventType enum value or -1 if not found.

## Description

Convert event name string to EventType enum value.

## Source

```gdscript
func _event_name_to_enum(event_name: String) -> int:
	match event_name:
		"MOVEMENT_STARTED":
			return EventType.MOVEMENT_STARTED
		"POSITION_REACHED":
			return EventType.POSITION_REACHED
		"CONTACT_SPOTTED":
			return EventType.CONTACT_SPOTTED
		"CONTACT_LOST":
			return EventType.CONTACT_LOST
		"TAKING_FIRE":
			return EventType.TAKING_FIRE
		"ENGAGING_TARGET":
			return EventType.ENGAGING_TARGET
		"AMMO_LOW":
			return EventType.AMMO_LOW
		"AMMO_CRITICAL":
			return EventType.AMMO_CRITICAL
		"FUEL_LOW":
			return EventType.FUEL_LOW
		"FUEL_CRITICAL":
			return EventType.FUEL_CRITICAL
		"ORDER_FAILED":
			return EventType.ORDER_FAILED
		"MOVEMENT_BLOCKED":
			return EventType.MOVEMENT_BLOCKED
		"MISSION_CONFIRMED":
			return EventType.MISSION_CONFIRMED
		"ROUNDS_SHOT":
			return EventType.ROUNDS_SHOT
		"ROUNDS_SPLASH":
			return EventType.ROUNDS_SPLASH
		"ROUNDS_IMPACT":
			return EventType.ROUNDS_IMPACT
		"BATTLE_DAMAGE_ASSESSMENT":
			return EventType.BATTLE_DAMAGE_ASSESSMENT
		"CASUALTIES_TAKEN":
			return EventType.CASUALTIES_TAKEN
		"COMMAND_CHANGE":
			return EventType.COMMAND_CHANGE
		"STRENGTH_REPORT":
			return EventType.STRENGTH_REPORT
		"COMBAT_INEFFECTIVE":
			return EventType.COMBAT_INEFFECTIVE
		"RESUPPLY_STARTED":
			return EventType.RESUPPLY_STARTED
		"RESUPPLY_EXHAUSTED":
			return EventType.RESUPPLY_EXHAUSTED
		"REFUEL_STARTED":
			return EventType.REFUEL_STARTED
		"REFUEL_EXHAUSTED":
			return EventType.REFUEL_EXHAUSTED
		_:
			push_warning("UnitAutoResponses: Unknown event type: %s" % event_name)
			return -1
```
