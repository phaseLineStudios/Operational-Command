# FuelSystem::register_scenario_unit Function Reference

*Defined at:* `scripts/sim/systems/FuelSystem.gd` (lines 53–74)</br>
*Belongs to:* [FuelSystem](../../FuelSystem.md)

**Signature**

```gdscript
func register_scenario_unit(su: ScenarioUnit, state: UnitFuelState = null) -> void
```

## Description

Public API

## Source

```gdscript
func register_scenario_unit(su: ScenarioUnit, state: UnitFuelState = null) -> void:
	## Register a ScenarioUnit together with its UnitFuelState. Subscribes to movement signals.
	if su == null or su.id == "":
		return
	_su[su.id] = su
	var s: UnitFuelState = state if state != null else UnitFuelState.new()
	if fuel_profile:
		fuel_profile.apply_defaults_if_missing(s)
	_fuel[su.id] = s
	_pos[su.id] = su.position_m
	_prev[su.id] = su.position_m
	_immobilized[su.id] = false

	## Keep positions fresh via movement signals and pass uid using bind().
	su.move_progress.connect(_on_move_progress.bind(su.id))
	su.move_started.connect(_on_move_started.bind(su.id))
	su.move_arrived.connect(_on_move_arrived.bind(su.id))
	su.move_blocked.connect(_on_move_blocked.bind(su.id))
	su.move_paused.connect(_on_move_paused.bind(su.id))
	su.move_resumed.connect(_on_move_resumed.bind(su.id))
```
