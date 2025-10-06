extends Control
class_name FuelRefuelPanel
## Minimal refuel panel (ammo-rearm style): choose per-unit amounts and consume a shared depot stock.
##
## Usage:
##   var panel := preload("res://ui/FuelRefuelPanel.tscn").instantiate()
##   add_child(panel)
##   panel.open(units_array, simworld.fuel_system(), 300.0)
##   panel.refuel_committed.connect(_on_refuel_done)
##
## Signals:
##   refuel_committed(plan: Dictionary[String, float], depot_after: float)

signal refuel_committed(plan: Dictionary[String, float], depot_after: float)

@export var slider_step: float = 0.5
@export var show_missing_in_label: bool = true

@onready var _title: Label       = %TitleLabel
@onready var _depot_lbl: Label   = %DepotLabel
@onready var _rows_box: VBoxContainer = %Rows
@onready var _btn_full: Button   = %FullButton
@onready var _btn_half: Button   = %HalfButton
@onready var _btn_cancel: Button = %CancelButton
@onready var _btn_commit: Button = %CommitButton

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
	_units = []
	for u in units: _units.append(u as ScenarioUnit)
	_fuel = fuel
	_depot = max(0.0, depot_stock)
	_title.text = title
	_build_rows()
	_update_depot_label()
	show()

func _build_rows() -> void:
	for c in _rows_box.get_children(): c.queue_free()
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
		slider.value_changed.connect(_on_slider_changed.bind(su.id, label))
		row.add_child(slider)

		var val := Label.new()
		val.custom_minimum_size = Vector2(70, 0)
		val.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		val.text = "0.0"
		row.add_child(val)

		_sliders[su.id] = slider
		_value_labels[su.id] = val

func _row_label_for(su: ScenarioUnit, st: UnitFuelState, missing: float) -> String:
	var name := (su.callsign if su.callsign != "" else su.id)
	if show_missing_in_label:
		return "%s  missing %.1f  (%.0f/%.0f)" % [name, missing, st.state_fuel, st.fuel_capacity]
	return "%s  (%.0f/%.0f)" % [name, st.state_fuel, st.fuel_capacity]

func _update_depot_label() -> void:
	_depot_lbl.text = "Depot: %.1f" % _depot

func _on_full() -> void:
	for id in _sliders.keys():
		var su: ScenarioUnit = _find_su(id)
		var st: UnitFuelState = _fuel.get_fuel_state(id)
		if su == null or st == null: continue
		var missing : float = max(0.0, st.fuel_capacity - st.state_fuel)
		_sliders[id].max_value = min(missing, _depot)
		_sliders[id].value = _sliders[id].max_value  # fill to cap or depot
	_value_labels_refresh()

func _on_half() -> void:
	for id in _sliders.keys():
		var su: ScenarioUnit = _find_su(id)
		var st: UnitFuelState = _fuel.get_fuel_state(id)
		if su == null or st == null: continue
		var missing : float = max(0.0, st.fuel_capacity - st.state_fuel)
		var half : float = min(missing * 0.5, _depot)
		_sliders[id].max_value = min(missing, _depot)
		_sliders[id].value = half
	_value_labels_refresh()

func _on_slider_changed(_v: float, uid: String, label_node: Label) -> void:
	## Keep per-row value label current and clamp by live depot availability.
	_value_labels[uid].text = "%.1f" % float(_sliders[uid].value)
	# recompute max by depot remainder for a responsive feel (optional)
	var remainder := _depot - _planned_total_except(uid)
	if remainder < 0.0:
		_sliders[uid].value = max(0.0, float(_sliders[uid].value) + remainder)  # trim overflow
		_value_labels[uid].text = "%.1f" % float(_sliders[uid].value)

func _planned_total_except(skip_uid: String) -> float:
	var sum := 0.0
	for id in _sliders.keys():
		if id == skip_uid: continue
		sum += float(_sliders[id].value)
	return sum

func _value_labels_refresh() -> void:
	for id in _value_labels.keys():
		_value_labels[id].text = "%.1f" % float(_sliders[id].value)

func _on_commit() -> void:
	## Apply sliders using FuelSystem.add_fuel and consume depot stock.
	if _fuel == null:
		hide()
		return

	var plan: Dictionary[String, float] = {}
	var requested := 0.0
	for id in _sliders.keys():
		var v := float(_sliders[id].value)
		if v > 0.0:
			plan[id] = v
			requested += v

	var spend : float = min(requested, _depot)
	var left := spend
	for id in plan.keys():
		if left <= 0.0: break
		var take : float = min(float(plan[id]), left)
		var added := _fuel.add_fuel(id, take)
		left -= added

	# update depot with any unspent remainder (capacity clamps, etc.)
	_depot = max(0.0, _depot - spend + left)
	_update_depot_label()

	emit_signal("refuel_committed", plan, _depot)
	hide()

func _find_su(id: String) -> ScenarioUnit:
	for su in _units:
		if su != null and su.id == id: return su
	return null
