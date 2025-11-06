# TriggerAPI::is_unit_in_combat Function Reference

*Defined at:* `scripts/sim/scenario/TriggerAPI.gd` (lines 379–399)</br>
*Belongs to:* [TriggerAPI](../../TriggerAPI.md)

**Signature**

```gdscript
func is_unit_in_combat(id_or_callsign: String) -> bool
```

- **id_or_callsign**: Unit ID or callsign to check.
- **Return Value**: True if unit has spotted enemies (in combat).

## Description

Check if a unit is currently in combat (has spotted enemies).
Returns true if the unit has line-of-sight to any enemy units.
  
  

**Usage in trigger condition:**

```
# Trigger when ALPHA unit is in combat
is_unit_in_combat("ALPHA")

# Trigger when any player unit is in combat
var u = unit("ALPHA")
if u:
is_unit_in_combat(u.id)

# Tutorial: explain combat when ambushed
is_unit_in_combat("ALPHA") and not has_global("combat_tutorial_shown")
```

## Source

```gdscript
func is_unit_in_combat(id_or_callsign: String) -> bool:
	if not sim:
		return false

	# Try to get unit to resolve callsign -> ID
	var unit_data := unit(id_or_callsign)
	var unit_id := ""
	if unit_data.has("id"):
		unit_id = unit_data.get("id", "")
	else:
		# Fallback: assume it's already an ID
		unit_id = id_or_callsign

	if unit_id == "":
		return false

	# Check if unit has any contacts (spotted enemies)
	var contacts: Array = sim.get_contacts_for_unit(unit_id)
	return contacts.size() > 0
```
