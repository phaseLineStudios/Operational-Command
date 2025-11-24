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


## Fill in caps/state/thresholds if the ScenarioUnit is missing them.
func apply_defaults_if_missing(su: ScenarioUnit) -> void:
	if su.unit.ammunition.is_empty():
		su.unit.ammunition = default_caps.duplicate(true)
	if su.state_ammunition.is_empty():
		for k in su.unit.ammunition.keys():
			su.state_ammunition[k] = int(su.unit.ammunition[k])
	if su.unit.ammunition_low_threshold <= 0.0:
		su.unit.ammunition_low_threshold = default_low_threshold
	if su.unit.ammunition_critical_threshold <= 0.0:
		su.unit.ammunition_critical_threshold = default_critical_threshold


## Serialize into JSON
func serialize() -> Dictionary:
	return {
		"default_caps": default_caps,
		"default_low_threshold": default_low_threshold,
		"default_critical_threshold": default_critical_threshold
	}


## Deserialize from JSON
static func deserialize(data: Variant) -> AmmoProfile:
	if typeof(data) != TYPE_DICTIONARY:
		return null

	var o := AmmoProfile.new()
	o.default_caps = data.get("default_caps", o.default_caps)
	o.default_low_threshold = float(data.get("default_low_threshold", o.default_low_threshold))
	o.default_critical_threshold = float(
		data.get("default_critical_threshold", o.default_critical_threshold)
	)

	return o
