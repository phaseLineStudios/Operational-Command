# UnitVoiceResponses::_generate_supply_report Function Reference

*Defined at:* `scripts/radio/UnitVoiceResponses.gd` (lines 328–380)</br>
*Belongs to:* [UnitVoiceResponses](../../UnitVoiceResponses.md)

**Signature**

```gdscript
func _generate_supply_report(unit: ScenarioUnit, callsign: String) -> String
```

- **unit**: ScenarioUnit to report on.
- **callsign**: Unit callsign.
- **Return Value**: Supply report string.

## Description

Generate supply report: ammunition and fuel status.

## Source

```gdscript
func _generate_supply_report(unit: ScenarioUnit, callsign: String) -> String:
	var parts: Array[String] = []

	parts.append(callsign)

	if sim_world and sim_world.ammo_system:
		var has_ammo := false
		for ammo_type in unit.unit.ammunition.keys():
			var cap: int = int(unit.unit.ammunition.get(ammo_type, 0))
			if cap > 0:
				has_ammo = true
				break

		if has_ammo:
			var ammo_status := "ammunition nominal"
			var lowest_pct := 100.0

			for ammo_type in unit.unit.ammunition.keys():
				var cap: int = int(unit.unit.ammunition.get(ammo_type, 0))
				if cap <= 0:
					continue
				var cur: int = int(unit.state_ammunition.get(ammo_type, 0))
				var pct := (float(cur) / float(cap)) * 100.0
				if pct < lowest_pct:
					lowest_pct = pct

			if lowest_pct <= 0:
				ammo_status = "ammunition winchester"
			elif lowest_pct <= unit.unit.ammunition_critical_threshold * 100.0:
				ammo_status = "ammunition critical"
			elif lowest_pct <= unit.unit.ammunition_low_threshold * 100.0:
				ammo_status = "ammunition low"

			parts.append(ammo_status)

	if sim_world and sim_world.fuel_system:
		var fuel_state = sim_world.fuel_system.get_fuel_state(unit.id)
		if fuel_state and fuel_state.fuel_capacity > 0:
			var fuel_pct: float = (fuel_state.state_fuel / fuel_state.fuel_capacity) * 100.0
			var fuel_status := "fuel nominal"

			if fuel_pct <= 0:
				fuel_status = "fuel empty"
			elif fuel_pct <= fuel_state.fuel_critical_threshold * 100.0:
				fuel_status = "fuel critical"
			elif fuel_pct <= fuel_state.fuel_low_threshold * 100.0:
				fuel_status = "fuel low"

			parts.append(fuel_status)

	return ". ".join(parts) + "."
```
