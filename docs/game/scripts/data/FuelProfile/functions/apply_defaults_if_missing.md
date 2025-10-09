# FuelProfile::apply_defaults_if_missing Function Reference

*Defined at:* `scripts/data/FuelProfile.gd` (lines 19–33)</br>
*Belongs to:* [FuelProfile](../../FuelProfile.md)

**Signature**

```gdscript
func apply_defaults_if_missing(state: UnitFuelState) -> void
```

## Description

Ensures that a given UnitFuelState has valid default values for all its fuel properties.
If any parameter (e.g., capacity, thresholds, or consumption rates) is unset or zero,
this function replaces it with predefined default values.

## Source

```gdscript
func apply_defaults_if_missing(state: UnitFuelState) -> void:
	if state == null:
		return
	if state.fuel_capacity <= 0.0:
		state.fuel_capacity = default_capacity
	if state.state_fuel <= 0.0:
		state.state_fuel = state.fuel_capacity
	if state.fuel_low_threshold <= 0.0:
		state.fuel_low_threshold = default_low_threshold
	if state.fuel_critical_threshold <= 0.0:
		state.fuel_critical_threshold = default_critical_threshold
	if state.fuel_idle_rate_per_s <= 0.0:
		state.fuel_idle_rate_per_s = default_idle_rate_per_s
	if state.fuel_move_rate_per_m <= 0.0:
		state.fuel_move_rate_per_m = default_move_rate_per_m
```
