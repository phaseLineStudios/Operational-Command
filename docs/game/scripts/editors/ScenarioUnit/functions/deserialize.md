# ScenarioUnit::deserialize Function Reference

*Defined at:* `scripts/editors/ScenarioUnit.gd` (lines 269–279)</br>
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
	return u
```
