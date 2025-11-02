# ScenarioUnit::serialize Function Reference

*Defined at:* `scripts/editors/ScenarioUnit.gd` (lines 277–289)</br>
*Belongs to:* [ScenarioUnit](../../ScenarioUnit.md)

**Signature**

```gdscript
func serialize() -> Dictionary
```

## Description

Serialize to JSON.

## Source

```gdscript
func serialize() -> Dictionary:
	return {
		"id": id,
		"unit_id": unit.id,
		"callsign": callsign,
		"position": ContentDB.v2(position_m),
		"affiliation": int(affiliation),
		"combat_mode": int(combat_mode),
		"behaviour": int(behaviour),
		"playable": playable
	}
```
