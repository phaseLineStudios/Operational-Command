extends Control
class_name FuelRefuelPanel
## Minimal refuel panel (ammo-rearm style): choose per-unit amounts and consume a shared depot stock.

signal refuel_committed(plan: Dictionary[String, float], depot_after: float)

@export var slider_step: float = 0.5
@export var show_missing_in_label: bool = true

@export var width_px: float = 280.0         # not used in VBox, kept for parity
@export var row_label_min_w: float = 130.0
@export var value_label_min_w: float = 50.0
@export var compact_font_size: int = 12

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
	# Make it look compact; let VBox drive the width
	add_theme_font_size_override("font_size", compact_font_size)
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	size_flags_vertical = 0
	custom_minimum_size.x = 0.0

	_btn_full.pressed.connect(_on_full)
	_btn_half.pressed.connect(_on_half)
	_btn_cancel.pressed.connect(func(): hide())
	_btn_commit.pressed.connect(_on_commit)

func open(units: Array, fuel: FuelSystem, depot_stock: float, title: String = "Refuel Units") -> void:
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

		var left_lbl := Label.new()
		left_lbl.custom_minimum_size = Vector2(row_label_min_w, 0.0)
		left_lbl.text = _row_label_for(su, st, missing)
		row.add_child(left_lbl)

		var slider := HSlider.new()
		slider.min_value = 0.0
		slider.max_value = min(missing, _depot)
		slider.step = slider_step
		slider.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		slider.value_changed.connect(_on_slider_changed.bind(su.id))
		row.add_child(slider)

		var val_lbl := Label.new()
		val_lbl.custom_minimum_size = Vector2(value_label_min_w, 0.0)
		val_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		val_lbl.text = "0.0"
		row.add_child(val_lbl)

		_sliders[su.id] = slider
		_value_labels[su.id] = val_lbl

func _row_label_for(su: ScenarioUnit, st: UnitFuelState, missing: float) -> String:
	var unit_label: String = (su.callsign if su.callsign != "" else su.id)
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
		var can_give: float = min(missing, _depot)
		var sl: HSlider = _sliders[id]
		sl.max_value = can_give
		sl.value = can_give
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
		var amount: float = float(_sliders[id].value)
		if amount > 0.0:
			plan[id] = amount
			requested += amount

	var spend: float = min(requested, _depot)
	var left_to_spend: float = spend

	for key in plan.keys():
		var uid: String = key as String
		if left_to_spend <= 0.0: break
		var want: float = min(float(plan[uid]), left_to_spend)
		var added: float = _apply_refuel(uid, want)
		left_to_spend -= added

	_depot = max(0.0, _depot - spend + left_to_spend)
	_update_depot_label()

	emit_signal("refuel_committed", plan, _depot)
	hide()

func _apply_refuel(uid: String, amount: float) -> float:
	if "add_fuel" in _fuel:
		return float(_fuel.add_fuel(uid, amount))
	var st: UnitFuelState = _fuel.get_fuel_state(uid)
	if st == null: return 0.0
	var missing: float = max(0.0, st.fuel_capacity - st.state_fuel)
	var give: float = min(missing, max(0.0, amount))
	if give > 0.0:
		st.state_fuel = min(st.fuel_capacity, st.state_fuel + give)
	return give
