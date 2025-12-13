# SimWorld::get_contacts_for_unit Function Reference

*Defined at:* `scripts/sim/SimWorld.gd` (lines 393–403)</br>
*Belongs to:* [SimWorld](../../SimWorld.md)

**Signature**

```gdscript
func get_contacts_for_unit(unit_id: String) -> Array
```

- **unit_id**: Unit ID to get contacts for.
- **Return Value**: Array of ScenarioUnit enemies in LOS.

## Description

Get enemy units that a specific unit can see (has LOS to).

## Source

```gdscript
func get_contacts_for_unit(unit_id: String) -> Array:
	var contacts: Array = []
	for pair in _contact_pairs:
		if pair.get("attacker", "") == unit_id:
			var enemy_id := str(pair.get("defender", ""))
			var enemy: ScenarioUnit = _units_by_id.get(enemy_id)
			if enemy != null:
				contacts.append(enemy)
	return contacts
```
