# TriggerAPI::is_unit_in_trigger_area Function Reference

*Defined at:* `scripts/sim/scenario/TriggerAPI.gd` (lines 263–280)</br>
*Belongs to:* [TriggerAPI](../../TriggerAPI.md)

**Signature**

```gdscript
func is_unit_in_trigger_area(callsign: String) -> bool
```

- **callsign**: Unit callsign to check.
- **Return Value**: True if unit is in trigger area, false otherwise or if not in trigger context.

## Description

Check if a specific unit is currently inside the trigger area.
Only works when called from within a trigger condition or action expression.
Checks across all affiliation categories (friend, enemy, player).

## Source

```gdscript
func is_unit_in_trigger_area(callsign: String) -> bool:
	# Get unit snapshot to resolve callsign to ID
	var unit_data := unit(callsign)
	if unit_data.is_empty():
		return false

	var unit_id: String = unit_data.get("id", "")
	if unit_id == "":
		return false

	# Check if unit is in any of the trigger area lists
	var friend_units := triggering_units_friend()
	var enemy_units := triggering_units_enemy()
	var player_units := triggering_units_player()

	return friend_units.has(unit_id) or enemy_units.has(unit_id) or player_units.has(unit_id)
```
