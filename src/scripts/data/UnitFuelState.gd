extends Resource
class_name UnitFuelState
## Per-unit fuel state and rates used by FuelSystem.

@export var fuel_capacity: float = 100.0
@export var state_fuel: float = 100.0

@export_range(0.0, 1.0, 0.01) var fuel_low_threshold: float = 0.25
@export_range(0.0, 1.0, 0.01) var fuel_critical_threshold: float = 0.10

## Idle burn in fuel units per second while not moving.
@export var fuel_idle_rate_per_s: float = 0.001
## Movement burn in fuel units per meter traveled.
@export var fuel_move_rate_per_m: float = 0.02

func ratio() -> float:
	if fuel_capacity <= 0.0:
		return 0.0
	return clamp(state_fuel / fuel_capacity, 0.0, 1.0)
