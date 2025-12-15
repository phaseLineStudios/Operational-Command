# TriggerAPI::set_unit_fuel Function Reference

*Defined at:* `scripts/sim/scenario/TriggerAPI.gd` (lines 440–480)</br>
*Belongs to:* [TriggerAPI](../../TriggerAPI.md)

**Signature**

```gdscript
func set_unit_fuel(id_or_callsign: String, fuel_pct: float) -> bool
```

- **id_or_callsign**: Unit ID or callsign.
- **fuel_pct**: Fuel percentage (0-100).
- **Return Value**: True if fuel was successfully set, false if unit or FuelSystem not found.

## Description

Set the fuel level of a unit (for scripted events and tutorials).
Fuel is specified as a percentage (0-100).

## Source

```gdscript
func set_unit_fuel(id_or_callsign: String, fuel_pct: float) -> bool:
	if not sim:
		return false

	# Resolve callsign to unit ID
	var unit_data := unit(id_or_callsign)
	var unit_id := ""
	if unit_data.has("id"):
		unit_id = unit_data.get("id", "")
	else:
		# Fallback: assume it's already an ID
		unit_id = id_or_callsign

	if unit_id == "":
		return false

	# Find FuelSystem in scene tree
	var fuel_system = null
	var tree := sim.get_tree()
	if tree:
		var nodes := tree.get_nodes_in_group("FuelSystem")
		if nodes.size() > 0:
			fuel_system = nodes[0]

	if fuel_system == null or not fuel_system.has_method("get_fuel_state"):
		return false

	# Get fuel state for this unit
	var fuel_state = fuel_system.get_fuel_state(unit_id)
	if fuel_state == null:
		return false

	# Clamp fuel percentage to 0-100 range
	var clamped_pct: float = clamp(fuel_pct, 0.0, 100.0)

	# Set fuel level (as percentage of capacity)
	fuel_state.state_fuel = (clamped_pct / 100.0) * fuel_state.fuel_capacity

	return true
```
