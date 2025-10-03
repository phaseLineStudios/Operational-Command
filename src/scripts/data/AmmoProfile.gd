extends Resource
class_name AmmoProfile
## Default caps and thresholds for units that do not define ammo.

@export var default_caps: Dictionary = {
	"small_arms": 30,
	"ap": 20,
	"he": 10,
	"atgm": 2
}
@export_range(0.0, 1.0, 0.01) var default_low_threshold: float = 0.25
@export_range(0.0, 1.0, 0.01) var default_critical_threshold: float = 0.1

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
