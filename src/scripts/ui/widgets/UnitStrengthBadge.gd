class_name UnitStrengthBadge
extends HBoxContainer
## Compact badge that shows unit strength percent and status color.

@export var understrength_threshold: float = 0.8

var _percent_lbl: Label = null
var _status_rect: ColorRect = null


## Create child UI nodes if needed. Safe to call before _ready().
func _ensure_ui() -> void:
	if _status_rect == null:
		_status_rect = ColorRect.new()
		_status_rect.custom_minimum_size = Vector2(12, 12)
		add_child(_status_rect)
	if _percent_lbl == null:
		_percent_lbl = Label.new()
		_percent_lbl.custom_minimum_size = Vector2(40, 0)
		_percent_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		add_child(_percent_lbl)
	add_theme_constant_override("separation", 4)


## Called when the node enters the scene tree.
func _ready() -> void:
	_ensure_ui()


## Update the badge from a UnitData. Creates UI if called before _ready().
func set_unit(u: UnitData, threshold: float = -1.0) -> void:
	_ensure_ui()
	if threshold > 0.0:
		understrength_threshold = threshold

	var cap: float = float(max(1, u.strength))
	var cur: float = float(max(0.0, u.state_strength))
	var pct: float = 0.0 if cur <= 0.0 else clamp(cur / cap, 0.0, 1.0)

	_percent_lbl.text = str(int(round(pct * 100.0))) + "%"

	# Status color: wiped out at exactly zero strength
	if cur <= 0.0:
		_status_rect.color = Color(0.8, 0.2, 0.2)
	elif pct < understrength_threshold:
		_status_rect.color = Color(0.95, 0.7, 0.1)
	else:
		_status_rect.color = Color(0.2, 0.8, 0.2)
