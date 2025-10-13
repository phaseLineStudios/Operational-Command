class_name AmmoProfile
extends Resource
## Resource that holds default ammo capacities and thresholds.
## Used by AmmoSystem when newly-registered units are missing values.

## Default per-type ammo capacities.
@export var default_caps: Dictionary = {"small_arms": 30, "ap": 20, "he": 10, "atgm": 2}

## Default low threshold (ratio of current/cap).
@export_range(0.0, 1.0, 0.01) var default_low_threshold: float = 0.25
## Default critical threshold (ratio of current/cap).
@export_range(0.0, 1.0, 0.01) var default_critical_threshold: float = 0.10


## Fill in caps/state/thresholds if the UnitData is missing them.
func apply_defaults_if_missing(u: UnitData) -> void:
	if u.ammunition.is_empty():
		u.ammunition = default_caps.duplicate(true)
	if u.state_ammunition.is_empty():
		for k in u.ammunition.keys():
			u.state_ammunition[k] = int(u.ammunition[k])
	if u.ammunition_low_threshold <= 0.0:
		u.ammunition_low_threshold = default_low_threshold
	if u.ammunition_critical_threshold <= 0.0:
		u.ammunition_critical_threshold = default_critical_threshold
