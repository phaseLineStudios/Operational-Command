extends Control
class_name FuelRefuelPanel
## Minimal refuel panel: choose per-unit amounts, consume a shared depot stock.

signal refuel_committed(plan: Dictionary[String, float], depot_after: float)

@export var title := "Refuel"
@export var visible_rows := 6

var _fuel: FuelSystem = null
var _units: Array[ScenarioUnit] = []
var _depot: float = 0.0
var _sliders: Dictionary[String, HSlider] = {}
var _rows: VBoxContainer
var _lbl_depot: Label

func _ready() -> void:
	_build_ui()

func open(units: Array, fuel: FuelSystem, depot_stock: float) -> void:
	_units = []
	for u in units:
		_units.append(u as ScenarioUnit)
	_fuel = fuel
	_depot = max(0.0, depot_stock)
	_populate_rows()
	show()

func _build_ui() -> void:
	hide()
	mouse_filter = Control.MOUSE_FILTER_PASS
	var root := VBoxContainer.new()
	root.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	root.size_flags_vertical = Control.SIZE_EXPAND_FILL
	add_child(root)

	var header := HBoxContainer.new()
	root.add_child(header)
	var lbl := Label.new()
	lbl.text = title
	header.add_child(lbl)
	_lbl_depot = Label.new()
	_lbl_depot.text = "Depot: 0"
	_lbl_depot.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_lbl_depot.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	header.add_child(_lbl_depot)

	var sc := ScrollContainer.new()
	sc.custom_minimum_size = Vector2(420, 28.0 * float(visible_rows))
	root.add_child(sc)
	_rows = VBoxContainer.new()
	_rows.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	sc.add_child(_rows)

	var row_btns := HBoxContainer.new()
	root.add_child(row_btns)
	var btn_full := Button.new(); btn_full.text = "Full"
	btn_full.pressed.connect(_on_full)
	row_btns.add_child(btn_full)
	var btn_half := Button.new(); btn_half.text = "Half"
	btn_half.pressed.connect(_on_half)
	row_btns.add_child(btn_half)
	var s := Control.new(); s.size_flags_horizontal = Control.SIZE_EXPAND_FILL; row_btns.add_child(s)
	var btn_commit := Button.new(); btn_commit.text = "Commit"
	btn_commit.pressed.connect(_on_commit)
	row_btns.add_child(btn_commit)

func _populate_rows() -> void:
	for c in _rows.get_children(): c.queue_free()
	_sliders.clear()
	var total_missing := 0.0
	for su in _units:
		if su == null: continue
		var st := _fuel.get_fuel_state(su.id)
		if st == null: continue
		var row := HBoxContainer.new()
		_rows.add_child(row)
		var label := Label.new()
		label.custom_minimum_size = Vector2(160, 0)
		var missing : float = max(0.0, st.fuel_capacity - st.state_fuel)
		total_missing += missing
		label.text = "%s  missing %.1f" % [su.callsign if su.callsign != "" else su.id, missing]
		row.add_child(label)
		var slider := HSlider.new()
		slider.min_value = 0.0
		slider.max_value = min(missing, _depot)
		slider.step = 0.5
		slider.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row.add_child(slider)
		_sliders[su.id] = slider
	_update_depot_label(total_missing)

func _update_depot_label(missing := 0.0) -> void:
	_lbl_depot.text = "Depot: %.1f  (need: %.1f)" % [_depot, missing]

func _on_full() -> void:
	for id in _sliders.keys():
		var su := _find_su(id)
		var st := _fuel.get_fuel_state(id)
		if su == null or st == null: continue
		var missing : float = max(0.0, st.fuel_capacity - st.state_fuel)
		_sliders[id].value = min(missing, _depot)

func _on_half() -> void:
	for id in _sliders.keys():
		var su := _find_su(id)
		var st := _fuel.get_fuel_state(id)
		if su == null or st == null: continue
		var missing : float = max(0.0, st.fuel_capacity - st.state_fuel)
		_sliders[id].value = min(missing * 0.5, _depot)

func _on_commit() -> void:
	var plan: Dictionary[String, float] = {}
	var sum := 0.0
	for id in _sliders.keys():
		var v := float(_sliders[id].value)
		if v > 0.0:
			plan[id] = v
			sum += v
	var spent : float = min(sum, _depot)
	# Apply plan using FuelSystem.add_fuel
	var left := spent
	for id in plan.keys():
		if left <= 0.0: break
		var want := float(plan[id])
		var take : float = min(want, left)
		var added := _fuel.add_fuel(id, take)
		left -= added
	_depot = max(0.0, _depot - spent + left) # refund any unspent if capped by capacity
	emit_signal("refuel_committed", plan, _depot)
	hide()

func _find_su(id: String) -> ScenarioUnit:
	for su in _units:
		if su != null and su.id == id: return su
	return null
