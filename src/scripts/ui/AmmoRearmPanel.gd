extends Control
class_name AmmoRearmPanel

## Emitted when the user commits changes.
## units_map example:
##   { "alpha": {"small_arms": +12, "stock:small_arms": +50} }
signal rearm_committed(units_map: Dictionary, depot_after: Dictionary)

@onready var _lst_units: ItemList       = %UnitList
@onready var _box_ammo: VBoxContainer   = %AmmoContainer
@onready var _lbl_depot: Label          = %Depot
@onready var _btn_full: Button          = %BtnFull
@onready var _btn_half: Button          = %BtnHalf
@onready var _btn_commit: Button        = %BtnCommit

var _units: Array[UnitData] = []
var _depot: Dictionary = {}                        # { ammo_type: amount }

# Typed holder for a slider row
class SliderEntry:
	var slider: HSlider
	var base: int

# Per-unit widgets
var _sliders_ammo: Dictionary = {}                 # { ammo_type: SliderEntry }
var _sliders_stock: Dictionary = {}                # { ammo_type: SliderEntry }
var _pending: Dictionary = {}                      # { uid: { ammo_key: +delta } }

# ---------- API ----------

func load_units(units: Array, depot_stock: Dictionary) -> void:
	var typed: Array[UnitData] = []
	for e in units:
		if e is UnitData:
			typed.append(e as UnitData)
	_units = typed
	_depot = depot_stock.duplicate(true)
	_refresh_units()
	_update_depot_label()

# ---------- lifecycle ----------

func _ready() -> void:
	_lst_units.item_selected.connect(_on_unit_selected)
	_btn_full.pressed.connect(func(): _apply_fill_ratio(1.0))
	_btn_half.pressed.connect(func(): _apply_fill_ratio(0.5))
	_btn_commit.pressed.connect(_on_commit)

# ---------- ui build ----------

func _refresh_units() -> void:
	_lst_units.clear()
	for i in range(_units.size()):
		var u: UnitData = _units[i]
		_lst_units.add_item("%s (%s)" % [u.title, u.id])
		_lst_units.set_item_tooltip(i, _ammo_tooltip(u))
	_clear_children(_box_ammo)
	_sliders_ammo.clear()
	_sliders_stock.clear()

func _on_unit_selected(idx: int) -> void:
	if idx < 0 or idx >= _units.size():
		return
	var u: UnitData = _units[idx]
	_build_controls_for(u)

func _build_controls_for(u: UnitData) -> void:
	_clear_children(_box_ammo)
	_sliders_ammo.clear()
	_sliders_stock.clear()

	# --- Section: Unit ammo (state_ammunition) ---
	if not u.ammunition.is_empty():
		_add_section_label("Unit ammo")
		for t in u.ammunition.keys():
			var cur: int = int(u.state_ammunition.get(t, 0))
			var cap: int = int(u.ammunition[t])
			var depot_avail: int = int(_depot.get(t, 0))
			var max_target: int = cur + int(min(cap - cur, depot_avail))

			var row := HBoxContainer.new()
			_box_ammo.add_child(row)

			var lab := Label.new()
			lab.text = "%s  %d/%d" % [str(t), cur, cap]
			row.add_child(lab)

			var slider := HSlider.new()
			slider.min_value = cur
			slider.max_value = max_target
			slider.step = 1.0
			slider.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			slider.value = cur
			row.add_child(slider)

			var val := Label.new()
			val.text = "→ %d (+0)" % [cur]
			row.add_child(val)

			var entry := SliderEntry.new()
			entry.slider = slider
			entry.base = cur
			_sliders_ammo[t] = entry

			slider.value_changed.connect(func(v: float) -> void:
				var delta: int = int(v) - cur
				val.text = "→ %d (%+d)" % [int(v), delta]
			)

	# --- Section: Logistics payload (throughput stock) ---
	if u.throughput is Dictionary and not u.throughput.is_empty():
		_add_section_label("Payload (logistics stock)")
		for t in u.throughput.keys():
			var cur_stock: int = int(u.throughput[t])
			var depot_avail2: int = int(_depot.get(t, 0))
			var max_target2: int = cur_stock + depot_avail2   # no explicit cap in spec

			var row2 := HBoxContainer.new()
			_box_ammo.add_child(row2)

			var lab2 := Label.new()
			lab2.text = "%s  stock %d" % [str(t), cur_stock]
			row2.add_child(lab2)

			var slider2 := HSlider.new()
			slider2.min_value = cur_stock
			slider2.max_value = max_target2
			slider2.step = 1.0
			slider2.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			slider2.value = cur_stock
			row2.add_child(slider2)

			var val2 := Label.new()
			val2.text = "→ %d (+0)" % [cur_stock]
			row2.add_child(val2)

			var entry2 := SliderEntry.new()
			entry2.slider = slider2
			entry2.base = cur_stock
			_sliders_stock[t] = entry2

			slider2.value_changed.connect(func(v: float) -> void:
				var delta2: int = int(v) - cur_stock
				val2.text = "→ %d (%+d)" % [int(v), delta2]
			)

# ---------- actions ----------

func _apply_fill_ratio(ratio: float) -> void:
	var sel := _lst_units.get_selected_items()
	if sel.is_empty():
		return
	var u: UnitData = _units[sel[0]]

	# Only auto-fill unit ammo. Payload stays manual.
	for t in u.ammunition.keys():
		var cur: int = int(u.state_ammunition.get(t, 0))
		var cap: int = int(u.ammunition[t])
		var depot_avail: int = int(_depot.get(t, 0))

		var want: int = int(round(float(cap) * ratio))
		var need: int = max(0, want - cur)
		var give: int = int(min(need, depot_avail))

		var entry: SliderEntry = _sliders_ammo.get(t, null) as SliderEntry
		if entry != null and entry.slider != null:
			entry.slider.value = cur + give  # updates the label via value_changed

func _on_commit() -> void:
	var sel := _lst_units.get_selected_items()
	if sel.is_empty():
		return
	var u: UnitData = _units[sel[0]]

	# Apply unit ammo deltas
	for t in _sliders_ammo.keys():
		var e: SliderEntry = _sliders_ammo.get(t, null) as SliderEntry
		if e == null or e.slider == null:
			continue
		var cur: int = e.base
		var target: int = int(e.slider.value)
		var want: int = max(0, target - cur)
		if want <= 0:
			continue

		var depot_avail: int = int(_depot.get(t, 0))
		var give: int = int(min(want, depot_avail))
		if give <= 0:
			continue

		u.state_ammunition[t] = int(u.state_ammunition.get(t, 0)) + give
		_depot[t] = depot_avail - give

		if not _pending.has(u.id):
			_pending[u.id] = {}
		var by_unit: Dictionary = _pending[u.id]
		by_unit[t] = int(by_unit.get(t, 0)) + give

	# Apply payload (throughput) deltas
	for t in _sliders_stock.keys():
		var e2: SliderEntry = _sliders_stock.get(t, null) as SliderEntry
		if e2 == null or e2.slider == null:
			continue
		var cur_s: int = e2.base
		var target_s: int = int(e2.slider.value)
		var want_s: int = max(0, target_s - cur_s)
		if want_s <= 0:
			continue

		var depot_avail2: int = int(_depot.get(t, 0))
		var give_s: int = int(min(want_s, depot_avail2))
		if give_s <= 0:
			continue

		u.throughput[t] = int(u.throughput.get(t, 0)) + give_s
		_depot[t] = depot_avail2 - give_s

		if not _pending.has(u.id):
			_pending[u.id] = {}
		var by_unit2: Dictionary = _pending[u.id]
		var key := "stock:%s" % [str(t)]
		by_unit2[key] = int(by_unit2.get(key, 0)) + give_s

	_refresh_units()
	_update_depot_label()
	emit_signal("rearm_committed", _pending.duplicate(true), _depot.duplicate(true))
	_pending.clear()

# ---------- helpers ----------

func _update_depot_label() -> void:
	var parts: Array[String] = []
	for t in _depot.keys():
		parts.append("%s %d" % [str(t), int(_depot[t])])
	_lbl_depot.text = "Depot: " + ", ".join(parts)

func _ammo_tooltip(u: UnitData) -> String:
	var lines: Array[String] = []
	for t in u.ammunition.keys():
		var cur: int = int(u.state_ammunition.get(t, 0))
		var cap: int = int(u.ammunition[t])
		lines.append("%s: %d/%d" % [str(t), cur, cap])
	if u.throughput is Dictionary and not u.throughput.is_empty():
		lines.append("[payload]")
		for t in u.throughput.keys():
			lines.append("%s: %d" % [str(t), int(u.throughput[t])])
	return "\n".join(lines)

func _add_section_label(title: String) -> void:
	var lab := Label.new()
	lab.text = title
	lab.add_theme_color_override("font_color", Color(1,1,1,0.9))
	_box_ammo.add_child(lab)

func _clear_children(n: Node) -> void:
	for c in n.get_children():
		(c as Node).queue_free()
