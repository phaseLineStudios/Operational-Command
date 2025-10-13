# SimWorld::init_world Function Reference

*Defined at:* `scripts/sim/SimWorld.gd` (lines 70–96)</br>
*Belongs to:* [SimWorld](../../SimWorld.md)

**Signature**

```gdscript
func init_world(scenario: ScenarioData) -> void
```

- **scenario**: ScenarioData to load.

## Description

Initialize world from a scenario and build unit indices.

## Source

```gdscript
func init_world(scenario: ScenarioData) -> void:
	_scenario = scenario
	_units_by_id.clear()
	_units_by_callsign.clear()
	_friendlies.clear()
	_enemies.clear()

	var all: Array = []
	all.append_array(scenario.units)
	all.append_array(scenario.playable_units)

	for su: ScenarioUnit in all:
		if su == null:
			continue
		_units_by_id[su.id] = su
		if su.callsign != "":
			_units_by_callsign[su.callsign] = su.id
		if su.affiliation == ScenarioUnit.Affiliation.FRIEND:
			_friendlies.append(su)
		else:
			_enemies.append(su)
		if su.playable:
			_playable_by_callsign[su.callsign] = su.id
	_router.bind_units(_units_by_id, _units_by_callsign)
	_transition(State.INIT, State.RUNNING)
```
