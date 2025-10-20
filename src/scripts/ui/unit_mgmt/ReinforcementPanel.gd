class_name ReinforcementPanel
extends Control
## Panel to allocate pre-mission personnel reinforcements from a shared pool.

signal reinforcement_preview_changed(unit_id: String, new_amount: int)
signal reinforcement_committed(assignments: Dictionary[String, int])

@export var understrength_threshold: float = 0.8
@export var slider_step: float = 1.0
@export var row_label_min_w: float = 140.0
@export var value_label_min_w: float = 54.0

var _units: Array[UnitData] = []
var _pool_total: int = 0
var _pool_remaining: int = 0
var _pending: Dictionary[String, int] = {}
var _rows: Dictionary[String, RowWidgets] = {}

@onready var _lbl_pool: Label = %PoolLabel
@onready var _rows_box: VBoxContainer = %RowsBox
@onready var _btn_commit: Button = %CommitBtn
@onready var _btn_reset: Button = %ResetBtn

class RowWidgets:
	var box: HBoxContainer
	var title: Label
	var badge: UnitStrengthBadge
	var minus: Button
	var value: Label
	var plus: Button
	var slider: HSlider
	var max_lbl: Label
	var base_title: String

	func _init(
		b: HBoxContainer, t: Label, badge_n: UnitStrengthBadge,
		m: Button, v: Label, p: Button, s: HSlider, ml: Label
	) -> void:
		box = b; title = t; badge = badge_n; minus = m
		value = v; plus = p; slider = s; max_lbl = ml
		base_title = ""

func _ready() -> void:
	if _btn_commit:
		_btn_commit.pressed.connect(commit)
	if _btn_reset:
		_btn_reset.pressed.connect(reset_pending)
	_update_pool_labels()
	_update_commit_enabled()

## Provide the list of units to display. Rebuild rows and clear any plan.
func set_units(units: Array[UnitData]) -> void:
	_units = []
	_rows.clear()
	_pending.clear()
	_clear_children(_rows_box)
	for u: UnitData in units:
		if u != null:
			_units.append(u)
	_build_rows()
	_update_pool_labels()
	_update_commit_enabled()

## Set available replacements in the pool and refresh UI.
func set_pool(amount: int) -> void:
	_pool_total = max(0, amount)
	_pool_remaining = _pool_total - _pending_sum()
	_update_pool_labels()
	if not is_node_ready():
		call_deferred("_update_pool_labels")
	_update_all_rows_state()
	_update_commit_enabled()

## Clear the pending plan back to zero for all units.
func reset_pending() -> void:
	_pending.clear()
	_pool_remaining = _pool_total
	for uid: String in _rows.keys():
		_emit_preview(uid, 0)
	_update_all_rows_state()
	_update_pool_labels()
	_update_commit_enabled()

## Emit the current plan to the owner. Does not mutate UnitData here.
func commit() -> void:
	var plan: Dictionary[String, int] = _pending.duplicate(true)
	# strip any zero/negative or wiped-out entries (if units list is present)
	for uid in plan.keys():
		var u := _find_unit(uid)
		if u == null or u.state_strength <= 0.0 or int(plan[uid]) <= 0:
			plan.erase(uid)
	emit_signal("reinforcement_committed", plan)

## Create row widgets for current units.
func _build_rows() -> void:
	for u: UnitData in _units:
		var uid: String = u.id
		var current: int = int(round(u.state_strength))
		var cap: int = int(max(0, u.strength))
		var missing: int = max(0, cap - current)

		var row := HBoxContainer.new()
		row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		_rows_box.add_child(row)

		var title := Label.new()
		title.custom_minimum_size = Vector2(row_label_min_w, 0.0)
		var base_title := (u.title if u.title != "" else uid)
		title.text = base_title
		row.add_child(title)

		var badge := UnitStrengthBadge.new()
		badge.custom_minimum_size = Vector2(60, 0)
		badge.set_unit(u, understrength_threshold)
		row.add_child(badge)

		var spacer := Control.new()
		spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row.add_child(spacer)

		var minus := Button.new(); minus.text = "-"
		row.add_child(minus)

		var val := Label.new()
		val.custom_minimum_size = Vector2(value_label_min_w, 0.0)
		val.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		val.text = str(int(_pending.get(uid, 0)))
		row.add_child(val)

		var plus := Button.new(); plus.text = "+"
		row.add_child(plus)

		var slider := HSlider.new()
		slider.step = slider_step
		slider.min_value = 0.0
		slider.max_value = float(missing)
		slider.value = float(_pending.get(uid, 0))
		slider.custom_minimum_size = Vector2(120, 0)
		row.add_child(slider)

		var max_lbl := Label.new()
		max_lbl.text = "/ %d" % missing
		row.add_child(max_lbl)

		var widgets := RowWidgets.new(row, title, badge, minus, val, plus, slider, max_lbl)
		widgets.base_title = base_title
		_rows[uid] = widgets

		minus.pressed.connect(func() -> void: _nudge(uid, -1))
		plus.pressed.connect(func() -> void: _nudge(uid, +1))
		slider.value_changed.connect(func(v: float) -> void: _set_amount(uid, int(round(v))))

	_update_all_rows_state()

## Enable/disable row interactivity.
func _disable_row(w: RowWidgets, disabled: bool) -> void:
	w.minus.disabled = disabled
	w.plus.disabled = disabled
	w.slider.editable = not disabled

## Refresh values, slider ranges, title/colour, and badge for all rows.
func _update_all_rows_state() -> void:
	for u: UnitData in _units:
		var uid: String = u.id
		var w: RowWidgets = _rows.get(uid, null)
		if w == null:
			continue
		var cur: int = int(round(u.state_strength))
		var cap: int = int(max(0, u.strength))
		var missing: int = max(0, cap - cur)
		var req: int = int(_pending.get(uid, 0))

		w.value.text = str(req)
		w.slider.max_value = float(missing)
		w.slider.value = float(req)
		w.max_lbl.text = "/ %d" % missing

		var wiped: bool = cur <= 0
		_disable_row(w, wiped or (_pool_remaining <= 0 and req <= 0))

		# Title styling toggles with state
		if wiped:
			w.title.text = w.base_title + " (Wiped Out)"
			w.title.add_theme_color_override("font_color", Color(1.0, 0.4, 0.4))
		else:
			w.title.text = w.base_title
			if w.title.has_theme_color_override("font_color"):
				w.title.remove_theme_color_override("font_color")

		# Badge reflects current state
		w.badge.set_unit(u, understrength_threshold)

	_update_pool_labels()

## Update the pool label.
func _update_pool_labels() -> void:
	var t := "Pool: %d / %d" % [_pool_remaining, _pool_total]
	if _lbl_pool:
		_lbl_pool.text = t

## Enable Commit button only when there is any planned change.
func _update_commit_enabled() -> void:
	if _btn_commit:
		_btn_commit.disabled = (_pending_sum() <= 0)

## Sum of all pending allocations.
func _pending_sum() -> int:
	var t: int = 0
	for v in _pending.values():
		t += int(v)
	return t

## Change planned amount by a delta.
func _nudge(uid: String, delta: int) -> void:
	var target: int = int(_pending.get(uid, 0)) + delta
	_set_amount(uid, target)

## Set planned amount for a unit (clamped to capacity and pool).
func _set_amount(uid: String, target: int) -> void:
	var u: UnitData = _find_unit(uid)
	if u == null:
		return
	var cur: int = int(round(u.state_strength))
	var cap: int = int(max(0, u.strength))
	var missing: int = max(0, cap - cur)
	var already: int = int(_pending.get(uid, 0))
	var room_in_pool: int = _pool_remaining + already

	var clamped: int = clampi(target, 0, min(missing, room_in_pool))
	_pending[uid] = clamped
	_pool_remaining = _pool_total - _pending_sum()
	_emit_preview(uid, clamped)
	_update_all_rows_state()
	_update_commit_enabled()

## Emit preview signal.
func _emit_preview(uid: String, amt: int) -> void:
	emit_signal("reinforcement_preview_changed", uid, amt)

## Find a UnitData by id.
func _find_unit(uid: String) -> UnitData:
	for u: UnitData in _units:
		if u != null and u.id == uid:
			return u
	return null

## Clear all children from a container.
func _clear_children(n: Node) -> void:
	for c in n.get_children():
		c.queue_free()
