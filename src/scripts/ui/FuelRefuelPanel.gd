extends Control
class_name FuelRefuelPanel
## Minimal refuel panel (ammo-rearm style): choose per-unit amounts and consume a shared depot stock.

signal refuel_committed(plan: Dictionary[String, float], depot_after: float)

@export var slider_step: float = 0.5
@export var show_missing_in_label: bool = true

# explicit node paths (no % shorthand required)
@onready var _title: Label            = $Panel/VBox/Header/TitleLabel
@onready var _depot_lbl: Label        = $Panel/VBox/Header/DepotLabel
@onready var _rows_box: VBoxContainer = $Panel/VBox/RowsScroll/Rows
@onready var _btn_full: Button        = $Panel/VBox/Footer/FullButton
@onready var _btn_half: Button        = $Panel/VBox/Footer/HalfButton
@onready var _btn_cancel: Button      = $Panel/VBox/Footer/CancelButton
@onready var _btn_commit: Button      = $Panel/VBox/Footer/CommitButton

var _fuel: FuelSystem = null
var _units: Array[ScenarioUnit] = []
var _depot: float = 0.0
var _sliders: Dictionary[String, HSlider] = {}
var _value_labels: Dictionary[String, Label] = {}

func _ready() -> void:
	_btn_full.pressed.connect(_on_full)
	_btn_half.pressed.connect(_on_half)
	_btn_cancel.pressed.connect(func(): hide())
	_btn_commit.pressed.connect(_on_commit)

func open(units: Array, fuel: FuelSystem, depot_stock: float, title: String = "Refuel Units") -> void:
	## Populate and show the panel.
	_units.clear()
	for u in units:
		_units.append(u as ScenarioUnit)
	_fuel = fuel
	_depot = max(0.0, depot_stock)
	_title.text = title
	_build_rows()
	_update_depot_label()
	show()

func _build_rows() -> void:
	for c in _rows_box.get_children():
		c.queue_free()
	_sliders.clear()
	_value_labels.clear()

	for su in _units:
		if su == null: continue
		var st: UnitFuelState = _fuel.get_fuel_state(su.id)
		if st == null: continue

		var missing: float = max(0.0, st.fuel_capacity - st.state_fuel)

		var row := HBoxContainer.new()
		row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		_rows_box.add_child(row)

		var label := Label.new()
		label.custom_minimum_size = Vector2(210, 0)
		label.text = _row_label_for(su, st, missing)
		row.add_child(label)

		var slider := HSlider.new()
		slider.min_value = 0.0
		slider.max_value = min(missing, _depot)
		slider.step = slider_step
		slider.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		slider.value_changed.connect(_on_slider_changed.bind(su.id))
		row.add_child(slider)

		var val := Label.new()
		val.custom_minimum_size = Vector2(70, 0)
		val.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		val.text = "0.0"
		row.add_child(val)

		_sliders[su.id] = slider
		_value_labels[su.id] = val

func _row_label_for(su: ScenarioUnit, st: UnitFuelState, missing: float) -> String:
	var unit_label: String = (su.callsign if su.callsign != "" else su.id) # avoid shadowing Node.name
	if show_missing_in_label:
		return "%s  missing %.1f  (%.0f/%.0f)" % [unit_label, missing, st.state_fuel, st.fuel_capacity]
	return "%s  (%.0f/%.0f)" % [unit_label, st.state_fuel, st.fuel_capacity]

func _update_depot_label() -> void:
	_depot_lbl.text = "Depot: %.1f" % _depot

func _on_full() -> void:
	for key in _sliders.keys():
		var id: String = key as String
		var st: UnitFuelState = _fuel.get_fuel_state(id)
		if st == null: continue
		var missing: float = max(0.0, st.fuel_capacity - st.state_fuel)
		var max_val: float = min(missing, _depot)
		var sl: HSlider = _sliders[id]
		sl.max_value = max_val
		sl.value = max_val
	_value_labels_refresh()

func _on_half() -> void:
	for key in _sliders.keys():
		var id: String = key as String
		var st: UnitFuelState = _fuel.get_fuel_state(id)
		if st == null: continue
		var missing: float = max(0.0, st.fuel_capacity - st.state_fuel)
		var half: float = min(missing * 0.5, _depot)
		var sl: HSlider = _sliders[id]
		sl.max_value = min(missing, _depot)
		sl.value = half
	_value_labels_refresh()

func _on_slider_changed(_v: float, uid: String) -> void:
	var sl: HSlider = _sliders[uid]
	var cur: float = float(sl.value)
	_value_labels[uid].text = "%.1f" % cur
	# Clamp by live depot remainder
	var remainder: float = _depot - _planned_total_except(uid)
	if remainder < 0.0:
		var trimmed: float = max(0.0, cur + remainder)
		sl.value = trimmed
		_value_labels[uid].text = "%.1f" % trimmed

func _planned_total_except(skip_uid: String) -> float:
	var sum: float = 0.0
	for key in _sliders.keys():
		var id: String = key as String
		if id == skip_uid: continue
		sum += float(_sliders[id].value)
	return sum

func _value_labels_refresh() -> void:
	for key in _value_labels.keys():
		var id: String = key as String
		_value_labels[id].text = "%.1f" % float(_sliders[id].value)

func _on_commit() -> void:
	if _fuel == null:
		hide()
		return

	var plan: Dictionary[String, float] = {}
	var requested: float = 0.0
	for key in _sliders.keys():
		var id: String = key as String
		var v: float = float(_sliders[id].value)
		if v > 0.0:
			plan[id] = v
			requested += v

	var spend: float = min(requested, _depot)
	var left: float = spend
	for key in plan.keys():
		var id: String = key as String
		if left <= 0.0:
			break
		var take: float = min(float(plan[id]), left)
		var added: float = _fuel.add_fuel(id, take)
		left -= added

	_depot = max(0.0, _depot - spend + left)
	_update_depot_label()
	emit_signal("refuel_committed", plan, _depot)
	hide()
