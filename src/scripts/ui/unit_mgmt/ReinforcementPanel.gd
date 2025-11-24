class_name ReinforcementPanel
extends VBoxContainer
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
## Temporary: tracks current strength per unit for campaign persistence (to be replaced)
var _unit_strength: Dictionary[String, float] = {}

@onready var _lbl_pool: Label = %PoolLabel
@onready var _rows_box: VBoxContainer = %RowsBox
@onready var _btn_commit: Button = %CommitBtn
@onready var _btn_reset: Button = %ResetBtn


class RowWidgets:
	var box: VBoxContainer
	var title: Label
	var badge: UnitStrengthBadge
	var current_max_label: Label
	var minus: Button
	var value: Label
	var plus: Button
	var slider: HSlider
	var max_lbl: Label
	var base_title: String

	func _init(
		b: VBoxContainer,
		t: Label,
		badge_n: UnitStrengthBadge,
		cml: Label,
		m: Button,
		v: Label,
		p: Button,
		s: HSlider,
		ml: Label
	) -> void:
		box = b
		title = t
		badge = badge_n
		current_max_label = cml
		minus = m
		value = v
		plus = p
		slider = s
		max_lbl = ml
		base_title = ""


func _ready() -> void:
	if _btn_commit:
		_btn_commit.pressed.connect(commit)
	if _btn_reset:
		_btn_reset.pressed.connect(reset_pending)
	_update_pool_labels()
	_update_commit_enabled()


## Provide the list of units to display. Rebuild rows and clear any plan.
## [param units] Array of UnitData templates.
## [param unit_strengths] Optional dictionary mapping unit_id -> current_strength (for campaign).
func set_units(units: Array[UnitData], unit_strengths: Dictionary = {}) -> void:
	_units = []
	_rows.clear()
	_pending.clear()
	_unit_strength.clear()
	_clear_children(_rows_box)
	for u: UnitData in units:
		if u != null:
			_units.append(u)
			# Initialize strength (from campaign state or default to full strength)
			var uid := u.id
			_unit_strength[uid] = float(unit_strengths.get(uid, float(u.strength)))
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
		var cur_strength: float = _unit_strength.get(uid, 0.0)
		if u == null or cur_strength <= 0.0 or int(plan[uid]) <= 0:
			plan.erase(uid)
	emit_signal("reinforcement_committed", plan)


## Create row widgets for current units.
func _build_rows() -> void:
	for u: UnitData in _units:
		var uid: String = u.id
		var current: int = int(round(_unit_strength.get(uid, 0.0)))
		var cap: int = int(max(0, u.strength))
		var missing: int = max(0, cap - current)

		# Main container for this unit (vertical stack)
		var unit_vbox := VBoxContainer.new()
		unit_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		unit_vbox.add_theme_constant_override("separation", 6)
		_rows_box.add_child(unit_vbox)

		# Top row: Title and Badge
		var top_row := HBoxContainer.new()
		top_row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		unit_vbox.add_child(top_row)

		var title := Label.new()
		var base_title := u.title if u.title != "" else uid
		title.text = base_title
		title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		top_row.add_child(title)

		var badge := UnitStrengthBadge.new()
		badge.custom_minimum_size = Vector2(60, 0)
		var thr := (
			u.understrength_threshold
			if u.understrength_threshold > 0.0
			else understrength_threshold
		)
		var cur_strength: float = _unit_strength.get(uid, 0.0)
		badge.set_unit(u, cur_strength, thr)
		top_row.add_child(badge)

		# Middle row: Current/Max label
		var current_max_label := Label.new()
		current_max_label.text = "Personnel: %d / %d" % [current, cap]
		unit_vbox.add_child(current_max_label)

		# Bottom row: Controls
		var controls_row := HBoxContainer.new()
		controls_row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		unit_vbox.add_child(controls_row)

		var minus := Button.new()
		minus.text = "-"
		controls_row.add_child(minus)

		var val := Label.new()
		val.custom_minimum_size = Vector2(value_label_min_w, 0.0)
		val.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		val.text = str(int(_pending.get(uid, 0)))
		controls_row.add_child(val)

		var plus := Button.new()
		plus.text = "+"
		controls_row.add_child(plus)

		var max_lbl := Label.new()
		max_lbl.text = "/ %d" % missing
		controls_row.add_child(max_lbl)

		# Slider on its own row below (shows total strength from 0, blocks below current)
		var slider := HSlider.new()
		slider.step = slider_step
		slider.min_value = 0.0
		slider.max_value = float(cap)
		slider.value = float(current + _pending.get(uid, 0))
		slider.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		unit_vbox.add_child(slider)

		var widgets := RowWidgets.new(
			unit_vbox, title, badge, current_max_label, minus, val, plus, slider, max_lbl
		)
		widgets.base_title = base_title
		_rows[uid] = widgets

		minus.pressed.connect(func() -> void: _nudge(uid, -1))
		plus.pressed.connect(func() -> void: _nudge(uid, +1))
		slider.value_changed.connect(
			func(v: float) -> void:
				var cur_str: int = int(round(_unit_strength.get(uid, 0.0)))
				var target_total: int = int(round(v))
				# Block slider from going below current strength
				if target_total < cur_str:
					slider.value = float(cur_str)
					return
				var reinforcements: int = target_total - cur_str
				_set_amount(uid, reinforcements)
		)

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
		var cur: int = int(round(_unit_strength.get(uid, 0.0)))
		var cap: int = int(max(0, u.strength))
		var missing: int = max(0, cap - cur)
		var req: int = int(_pending.get(uid, 0))

		w.value.text = str(req)
		w.slider.min_value = 0.0
		w.slider.max_value = float(cap)
		# Ensure slider value doesn't go below current strength
		var target_value: float = float(cur + req)
		if target_value < float(cur):
			target_value = float(cur)
		w.slider.value = target_value
		w.max_lbl.text = "/ %d" % missing
		w.current_max_label.text = "Personnel: %d / %d" % [cur, cap]

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
		var thr := (
			u.understrength_threshold
			if u.understrength_threshold > 0.0
			else understrength_threshold
		)
		var cur_strength: float = _unit_strength.get(uid, 0.0)
		w.badge.set_unit(u, cur_strength, thr)

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
	var cur: int = int(round(_unit_strength.get(uid, 0.0)))
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


## Public: re-read UnitData and refresh all UI from the current state.
func refresh_from_units() -> void:
	_update_all_rows_state()
	_update_pool_labels()
	_update_commit_enabled()
