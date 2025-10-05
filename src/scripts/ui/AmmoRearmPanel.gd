extends Control
class_name AmmoRearmPanel
## Pre-mission rearm UI.
## - Shows units with ammo tooltips.
## - Per-ammo HSliders to choose target amounts.
## - Honors a limited mission depot stock (separate from in-field logistics stock).
## - Emits `rearm_committed(units_map, depot_after)` on Commit.

signal rearm_committed(units_map: Dictionary, depot_after: Dictionary)

@onready var _lst_units: ItemList       = %UnitList
@onready var _box_ammo: VBoxContainer   = %AmmoContainer
@onready var _lbl_depot: Label          = %Depot
@onready var _btn_full: Button          = %BtnFull
@onready var _btn_half: Button          = %BtnHalf
@onready var _btn_commit: Button        = %BtnCommit

var _units: Array[UnitData] = []
var _depot: Dictionary = {}       # e.g., { "small_arms": 300 }
var _sliders: Dictionary = {}     # ammo_type -> HSlider
var _pending: Dictionary = {}     # { uid: { ammo_type: +delta } }

func load_units(units: Array, depot_stock: Dictionary) -> void:
	# Safely convert the generic Array to Array[UnitData]
	var typed: Array[UnitData] = []
	for e in units:
		if e is UnitData:
			typed.append(e as UnitData)
	_units = typed

	_depot = depot_stock.duplicate(true)
	_refresh_units()
	_update_depot_label()

func _ready() -> void:
	_lst_units.item_selected.connect(_on_unit_selected)
	_btn_full.pressed.connect(func(): _apply_fill_ratio(1.0))
	_btn_half.pressed.connect(func(): _apply_fill_ratio(0.5))
	_btn_commit.pressed.connect(_on_commit)

func _refresh_units() -> void:
	_lst_units.clear()
	for i in range(_units.size()):
		var u: UnitData = _units[i]
		_lst_units.add_item("%s (%s)" % [u.title, u.id])
		_lst_units.set_item_tooltip(i, _ammo_tooltip(u))
	_sliders.clear()
	_clear_children(_box_ammo)

func _on_unit_selected(idx: int) -> void:
	var u: UnitData = _units[idx]
	_build_sliders_for(u)

func _build_sliders_for(u: UnitData) -> void:
	_sliders.clear()
	_clear_children(_box_ammo)

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

		_sliders[t] = slider
		slider.value_changed.connect(func(v: float) -> void:
			var delta: int = int(v) - cur
			val.text = "→ %d (%+d)" % [int(v), delta]
		)

func _apply_fill_ratio(ratio: float) -> void:
	var sel := _lst_units.get_selected_items()
	if sel.is_empty():
		return
	var u: UnitData = _units[sel[0]]

	for t in u.ammunition.keys():
		var cur: int = int(u.state_ammunition.get(t, 0))
		var cap: int = int(u.ammunition[t])
		var depot_avail: int = int(_depot.get(t, 0))

		var want: int = int(round(float(cap) * ratio))
		var need: int = max(0, want - cur)
		var give: int = int(min(need, depot_avail))

		var slider: HSlider = _sliders.get(t, null)
		if slider:
			slider.value = cur + give  # updates the label via value_changed

func _on_commit() -> void:
	var sel := _lst_units.get_selected_items()
	if sel.is_empty():
		return
	var u: UnitData = _units[sel[0]]

	# Compute deltas, clamp to depot, apply to unit, reduce depot, and track pending.
	for t in _sliders.keys():
		var slider: HSlider = _sliders[t]
		var cur: int = int(u.state_ammunition.get(t, 0))
		var target: int = int(slider.value)
		var want: int = max(0, target - cur)
		if want <= 0:
			continue

		var depot_avail: int = int(_depot.get(t, 0))
		var give: int = int(min(want, depot_avail))
		if give <= 0:
			continue

		u.state_ammunition[t] = cur + give
		_depot[t] = depot_avail - give

		if not _pending.has(u.id):
			_pending[u.id] = {}
		var by_unit: Dictionary = _pending[u.id]
		by_unit[t] = int(by_unit.get(t, 0)) + give

	_refresh_units()
	_update_depot_label()
	emit_signal("rearm_committed", _pending.duplicate(true), _depot.duplicate(true))
	_pending.clear()

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
	return "\n".join(lines)

func _clear_children(n: Node) -> void:
	for c in n.get_children():
		(c as Node).queue_free()
