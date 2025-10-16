class_name UnitStrengthBadge
extends HBoxContainer
## Compact badge that shows unit strength percent and status color.
## Use in lists and cards.
##
## Status rules:
##   - WIPED_OUT if state_strength <= 0.5
##   - UNDERSTRENGTH if state_strength / strength < understrength_threshold
##   - ACTIVE otherwise

@export var understrength_threshold: float = 0.8

var _percent_lbl: Label
var _status_rect: ColorRect

func _ready() -> void:
	add_theme_constant_override("separation", 4)
	_status_rect = ColorRect.new()
	_status_rect.custom_minimum_size = Vector2(12, 12)
	add_child(_status_rect)

	_percent_lbl = Label.new()
	_percent_lbl.custom_minimum_size = Vector2(40, 0)
	_percent_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	add_child(_percent_lbl)

## Update the badge. Provide a unit and optionally threshold.
func set_unit(u: UnitData, threshold: float = -1.0) -> void:
	if threshold > 0.0:
		understrength_threshold = threshold
	var cap: float = float(max(1, u.strength))
	var cur: float = float(max(0.0, u.state_strength))
	var pct: float = 0.0 if cur <= 0.0 else clamp(cur / cap, 0.0, 1.0)
	_percent_lbl.text = str(int(round(pct * 100.0))) + "%"

	var wiped: bool = cur <= 0.5
	if wiped:
		_status_rect.color = Color(0.8, 0.2, 0.2)
		return

	if pct < understrength_threshold:
		_status_rect.color = Color(0.95, 0.7, 0.1)
	else:
		_status_rect.color = Color(0.2, 0.8, 0.2)
