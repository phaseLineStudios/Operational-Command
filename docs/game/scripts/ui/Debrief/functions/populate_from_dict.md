# Debrief::populate_from_dict Function Reference

*Defined at:* `scripts/ui/Debrief.gd` (lines 307–324)</br>
*Belongs to:* [Debrief](../../Debrief.md)

**Signature**

```gdscript
func populate_from_dict(d: Dictionary) -> void
```

## Description

Populates the entire UI from a single dictionary.
Keys:
{
"mission_name": String,
"outcome": String,
"objectives": Array,      see set_objectives_results()
"score": Dictionary,      see set_score()
"casualties": Dictionary, see set_casualties()
"units": Array,           see set_units()
"commendations": Array    list of award names
}

## Source

```gdscript
func populate_from_dict(d: Dictionary) -> void:
	if d.has("mission_name"):
		set_mission_name(str(d["mission_name"]))
	if d.has("outcome"):
		set_outcome(str(d["outcome"]))
	if d.has("objectives"):
		set_objectives_results(d["objectives"])
	if d.has("score"):
		set_score(d["score"])
	if d.has("casualties"):
		set_casualties(d["casualties"])
	if d.has("units"):
		set_units(d["units"])
		set_recipients_from_units()
	if d.has("commendations"):
		set_commendation_options(d["commendations"])
```
