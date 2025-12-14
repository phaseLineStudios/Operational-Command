# ScenarioUnit::deserialize Function Reference

*Defined at:* `scripts/editors/ScenarioUnit.gd` (lines 374–418)</br>
*Belongs to:* [ScenarioUnit](../../ScenarioUnit.md)

**Signature**

```gdscript
func deserialize(d: Dictionary) -> ScenarioUnit
```

## Description

Deserialzie from JSON.

## Source

```gdscript
static func deserialize(d: Dictionary) -> ScenarioUnit:
	var u := ScenarioUnit.new()
	u.id = d.get("id")
	u.unit = ContentDB.get_unit(d.get("unit_id"))
	u.callsign = d.get("callsign", "unit")
	u.position_m = ContentDB.v2_from(d.get("position"))
	u.affiliation = int(d.get("affiliation")) as Affiliation
	u.combat_mode = int(d.get("combat_mode")) as CombatMode
	u.behaviour = int(d.get("behaviour")) as Behaviour
	u.playable = d.get("playable", u.playable)

	# Initialize state from template first (ensure defaults are always set)
	if u.unit:
		u.state_strength = u.unit.strength
		u.state_equipment = 1.0
		u.cohesion = 1.0
		u.state_ammunition = u.unit.ammunition.duplicate()
	else:
		push_warning(
			(
				"ScenarioUnit.deserialize: unit is null for id=%s, unit_id=%s"
				% [u.id, d.get("unit_id")]
			)
		)
		u.state_strength = 0.0
		u.state_equipment = 0.0
		u.cohesion = 0.0

	# Override with saved state if present
	var state: Dictionary = d.get("state", {})
	if typeof(state) == TYPE_DICTIONARY and not state.is_empty():
		if state.has("state_strength"):
			u.state_strength = float(state.get("state_strength"))
		if state.has("state_injured"):
			u.state_injured = float(state.get("state_injured"))
		if state.has("state_equipment"):
			u.state_equipment = float(state.get("state_equipment"))
		if state.has("cohesion"):
			u.cohesion = float(state.get("cohesion"))
		if state.has("state_ammunition"):
			var ammo_state = state.get("state_ammunition")
			if typeof(ammo_state) == TYPE_DICTIONARY:
				u.state_ammunition = ammo_state

	return u
```
