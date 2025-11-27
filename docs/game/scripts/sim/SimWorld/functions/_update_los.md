# SimWorld::_update_los Function Reference

*Defined at:* `scripts/sim/SimWorld.gd` (lines 257–315)</br>
*Belongs to:* [SimWorld](../../SimWorld.md)

**Signature**

```gdscript
func _update_los() -> void
```

## Description

Computes LOS contact pairs once per tick and emits contact events.
Optimized to only check LOS between units when at least one has moved.

## Source

```gdscript
func _update_los() -> void:
	if los_adapter == null:
		return

	# Determine which units have moved since last tick
	var moved_units: Dictionary = {}
	for unit in _friendlies + _enemies:
		if unit.is_dead():
			continue
		var current_pos := unit.position_m
		var last_pos: Variant = _unit_positions.get(unit.id)

		# Check if position changed (or first time seeing this unit)
		if last_pos == null or current_pos.distance_to(last_pos) > 0.01:
			moved_units[unit.id] = true
			_unit_positions[unit.id] = current_pos

	# Build new contact pairs - only check LOS if at least one unit moved
	var new_contacts: PackedStringArray = []
	var old_contacts_dict: Dictionary = {}

	# Convert old contacts to dictionary for fast lookup
	for contact in _last_contacts:
		old_contacts_dict[contact] = true

	# Check all friend-enemy pairs
	for f in _friendlies:
		if f.is_dead():
			continue
		for e in _enemies:
			if e.is_dead():
				continue

			var key := "%s|%s" % [f.id, e.id]
			var f_moved := moved_units.has(f.id)
			var e_moved := moved_units.has(e.id)

			# If neither moved, keep existing contact state
			if not f_moved and not e_moved:
				if old_contacts_dict.has(key):
					new_contacts.append(key)
				continue

			# At least one moved - check LOS
			if los_adapter.has_los(f, e):
				new_contacts.append(key)

	_last_contacts = new_contacts
	_contact_pairs.clear()

	for key in _last_contacts:
		var parts := key.split("|")
		_contact_pairs.append({"attacker": parts[0], "defender": parts[1]})

		# Emit signal only for new contacts
		if not old_contacts_dict.has(key):
			emit_signal("contact_reported", parts[0], parts[1])
```
