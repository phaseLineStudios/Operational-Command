class_name UnitCreateDialog
extends Window
## Create/edit UnitData and save to res://data/units/<id>.json.
## Uses OptionButtons for Category/Size/MoveProfile and addable lists for Slots/Equipment/Throughput.

## Emitted after a successful save.
signal unit_saved(unit: UnitData, path: String)
## Emitted when canceled.
signal canceled

## Dialog mode.
enum DialogMode { CREATE, EDIT }

## Equipment category.
enum EquipCategory { VEHICLES, WEAPONS, RADIOS }

var _mode: DialogMode = DialogMode.CREATE
var _working: UnitData

# ---------- UI ----------
@onready var _id: LineEdit         = %Id
@onready var _title: LineEdit      = %Title
@onready var _role: LineEdit       = %Role
@onready var _cost: SpinBox        = %Cost
@onready var _strength: SpinBox    = %Strength
@onready var _attack: SpinBox      = %Attack
@onready var _defense: SpinBox     = %Defense
@onready var _spot_m: SpinBox      = %Spot
@onready var _range_m: SpinBox     = %Range
@onready var _morale: SpinBox      = %Morale
@onready var _speed_kph: SpinBox   = %Speed

@onready var _category_ob: OptionButton   = %Category
@onready var _size_ob: OptionButton       = %Size
@onready var _move_ob: OptionButton       = %MoveProfile

# Allowed slots list
@onready var _slot_input: LineEdit        = %SlotInput
@onready var _slot_add: Button            = %SlotAdd
@onready var _slots_list: VBoxContainer   = %SlotsVBox

# Equipment list (key:any, value:any)
@onready var _equip_cat: OptionButton     = %EquipmentCategory
@onready var _equip_key: LineEdit         = %EquipmentType
@onready var _equip_val: SpinBox          = %EquipmentAmount
@onready var _equip_add: Button           = %EquipmentAdd
@onready var _equip_list: VBoxContainer   = %EquipmentList

# Throughput list (key:string, value:number)
@onready var _th_key: LineEdit            = %ThroughputType
@onready var _th_val: SpinBox             = %ThroughputAmount
@onready var _th_add: Button              = %ThroughputAdd
@onready var _th_list: VBoxContainer      = %ThroughputList

@onready var _save_btn: Button            = %Save
@onready var _cancel_btn: Button          = %Close
@onready var _error_dlg: AcceptDialog     = %ErrorDialog

# ---------- State ----------
var _slots: Array[String] = []              ## Live mirror of Allowed Slots
var _equip := { "vehicles": {}, "weapons": {}, "radios": {} }
var _thru  := {}                            ## Live mirror of Throughput
var _cat_items: Array = []                  ## [{id, title, res}, ...]

# ---------- Wiring ----------
func _ready() -> void:
	_populate_size()
	_populate_move_profile()
	_populate_categories()
	
	for cat in EquipCategory.keys():
		_equip_cat.add_item(cat)

	_slot_add.pressed.connect(_on_add_slot)
	_equip_add.pressed.connect(_on_add_equip)
	_th_add.pressed.connect(_on_add_throughput)

	_save_btn.pressed.connect(_on_save_pressed)
	_cancel_btn.pressed.connect(_on_cancel_pressed)
	close_requested.connect(_on_cancel_pressed)

## Open dialog (CREATE if unit == null).
func show_dialog(state: bool, unit: UnitData = null) -> void:
	if not state:
		hide()
		_reset_ui()
		return
	_mode = DialogMode.EDIT if unit != null else DialogMode.CREATE
	_working = (unit.duplicate(true) as UnitData) if unit != null else UnitData.new()
	_load_from_working()
	popup_centered_ratio(0.72)

# ---------- Load/Collect ----------
## Load UI from working data.
func _load_from_working() -> void:
	# Defaults for new units
	if _mode == DialogMode.CREATE:
		if String(_working.role) == "": _working.role = "INF"
		if _working.allowed_slots.is_empty(): _working.allowed_slots = ["INF"]
		if _working.size == null: _working.size = UnitData.UnitSize.PLATOON
		if _working.morale == 0.0: _working.morale = 0.9
		if _working.movement_profile == null: 
			_working.movement_profile = _default_move_profile() as TerrainBrush.MoveProfile

	# Simple fields
	_id.text = String(_working.id)
	_title.text = String(_working.title)
	_role.text = String(_working.role)
	_cost.value = _working.cost
	_strength.value = _working.strength
	_attack.value = _working.attack
	_defense.value = _working.defense
	_spot_m.value = _working.spot_m
	_range_m.value = _working.range_m
	_morale.value = _working.morale
	_speed_kph.value = _working.speed_kph

	# Enums
	_select_size(_working.size)
	_select_move_profile(_working.movement_profile)
	_select_category(_working.unit_category)

	# Lists → rows
	_slots.clear()
	for s in _working.allowed_slots:
		_add_slot_row(String(s))
	_slots = _working.allowed_slots.duplicate()

	_reset_equip()
	for c in _working.equipment.keys():
		if typeof(_working.equipment[c]) == TYPE_DICTIONARY:
			for k in _working.equipment[c].keys():
				_add_kv_row(_equip_list, String(k), _working.equipment[k], _on_delete_equip_row, c)
				_equip[c][k] = _working.equipment[k]
		else:
			_add_kv_row(_equip_list, String(c), _working.equipment[c], _on_delete_equip_row)
			_equip[c] = _working.equipment[c]

	_thru.clear()
	for k in _working.throughput.keys():
		_add_kv_row(_th_list, String(k), _working.throughput[k], _on_delete_throughput_row)
		_thru[k] = _working.throughput[k]

## Apply UI → working data.
func _collect_into_working() -> void:
	_working.id = _require_id(_id.text)
	_working.title = _title.text.strip_edges()
	_working.role = _role.text.strip_edges()
	_working.cost = int(_cost.value)
	_working.strength = int(_strength.value)
	_working.attack = float(_attack.value)
	_working.defense = float(_defense.value)
	_working.spot_m = float(_spot_m.value)
	_working.range_m = float(_range_m.value)
	_working.morale = clamp(float(_morale.value), 0.0, 1.0)
	_working.speed_kph = float(_speed_kph.value)

	_working.size = int(_size_ob.get_selected_id()) as UnitData.UnitSize
	_working.movement_profile = int(_move_ob.get_selected_id()) as TerrainBrush.MoveProfile

	_working.allowed_slots = _slots.duplicate()
	_working.equipment = _equip.duplicate()
	_working.throughput = _thru.duplicate()

	# Category from OptionButton metadata
	var cat_meta = _category_ob.get_item_metadata(_category_ob.get_selected())
	if typeof(cat_meta) == TYPE_DICTIONARY and cat_meta.has("res"):
		_working.unit_category = cat_meta["res"]

# ---------- Save ----------
func _on_save_pressed() -> void:
	var msg := _validate()
	if msg != "":
		return _error(msg)
	_collect_into_working()
	if _save_to_file():
		hide()
		emit_signal("unit_saved", _working, "res://data/units/%s.json" % _working.id)

func _on_cancel_pressed() -> void:
	hide()
	emit_signal("canceled")

func _save_to_file() -> bool:
	var dir_path := "res://data/units"
	var file_path := "%s/%s.json" % [dir_path, _working.id]
	var mk := DirAccess.make_dir_recursive_absolute(dir_path)
	if mk != OK and mk != ERR_ALREADY_EXISTS:
		_error("Failed to create: %s (err %d)" % [dir_path, mk]); return false
	var f := FileAccess.open(file_path, FileAccess.WRITE)
	if f == null:
		_error("Failed to write: %s (err %d)" % [file_path, FileAccess.get_open_error()]); return false
	f.store_string(JSON.stringify(_working.serialize(), "  "))
	f.flush(); f.close()
	return true

# ---------- Validation ----------
func _validate() -> String:
	if _id.text.strip_edges() == "": return _error("Unit ID is required.")
	if _title.text.strip_edges() == "": return _error("Title is required.")
	if _role.text.strip_edges() == "": return _error("Role is required.")
	if _slots.is_empty(): return _error("At least one Allowed Slot is required.")
	if _category_ob.get_selected() < 0: return _error("Select a Category.")
	return ""

# ---------- Enum/Options ----------
func _populate_size() -> void:
	_size_ob.clear()
	_size_ob.add_item("TEAM", UnitData.UnitSize.TEAM)
	_size_ob.add_item("SQUAD", UnitData.UnitSize.SQUAD)
	_size_ob.add_item("PLATOON", UnitData.UnitSize.PLATOON)
	_size_ob.add_item("COMPANY", UnitData.UnitSize.COMPANY)
	_size_ob.add_item("BATTALION", UnitData.UnitSize.BATTALION)

func _populate_move_profile() -> void:
	_move_ob.clear()
	# TerrainBrush.MoveProfile is an enum (dictionary-like)
	var mp = TerrainBrush.MoveProfile
	for mp_name in mp.keys():
		_move_ob.add_item(String(mp_name), int(mp[mp_name]))

func _populate_categories() -> void:
	_category_ob.clear()
	_cat_items.clear()
	var cats := ContentDB.list_unit_categories()
	for c in cats:
		var cat_title := c.title
		var id := c.id
		var idx := _category_ob.item_count
		_category_ob.add_item(cat_title, idx)
		_category_ob.set_item_metadata(idx, {"id": id, "res": c})
	_cat_items = cats

func _select_size(v: int) -> void:
	for i in _size_ob.item_count:
		if _size_ob.get_item_id(i) == int(v):
			_size_ob.select(i); return

func _select_move_profile(v: int) -> void:
	for i in _move_ob.item_count:
		if _move_ob.get_item_id(i) == int(v):
			_move_ob.select(i); return

func _select_category(cat: UnitCategoryData) -> void:
	if cat == null: return
	for i in _category_ob.item_count:
		var meta = _category_ob.get_item_metadata(i)
		if typeof(meta) == TYPE_DICTIONARY and meta.has("id"):
			if String(meta["id"]) == String(cat.get("id") if cat.has_method("get") else cat.id):
				_category_ob.select(i); return

# ---------- Lists: Slots / Equipment / Throughput ----------
func _on_add_slot() -> void:
	var s := _slot_input.text.strip_edges().to_upper()
	if s == "": return
	if s in _slots: return
	_slots.append(s)
	_add_slot_row(s)
	_slot_input.clear()

func _add_slot_row(s: String) -> void:
	var row := HBoxContainer.new()
	row.custom_minimum_size.y = 26
	row.set_meta("slot", s)

	var lbl := Label.new(); lbl.text = s
	lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	var del := Button.new(); del.text = "Delete"
	del.pressed.connect(func():
		_slots.erase(row.get_meta("slot"))
		row.queue_free()
	)

	row.add_child(lbl)
	row.add_child(del)
	_slots_list.add_child(row)

func _on_add_equip() -> void:
	var c := _equip_cat.selected as EquipCategory
	var c_str := EquipCategory.keys()[c] as String
	var k := _equip_key.text.strip_edges()
	var v := int(_equip_val.value)
	if k == "": return
	# Replace if exists
	if _equip.has(k):
		_replace_kv_row(_equip_list, k, v, c_str.to_lower())
	else:
		_add_kv_row(_equip_list, k, v, _on_delete_equip_row, c_str.to_lower())
	_equip[c_str.to_lower()][k] = v
	_equip_key.text = ""; _equip_val.value = 0

func _on_delete_equip_row(key: String, row: HBoxContainer) -> void:
	_equip.erase(key); row.queue_free()

func _on_add_throughput() -> void:
	var k := _th_key.text.strip_edges()
	var v := float(_th_val.value)
	if k == "": return
	if _thru.has(k):
		_replace_kv_row(_th_list, k, v)
	else:
		_add_kv_row(_th_list, k, v, _on_delete_throughput_row)
	_thru[k] = v
	_th_key.clear(); _th_val.value = 0.0

func _on_delete_throughput_row(key: String, row: HBoxContainer) -> void:
	_thru.erase(key); row.queue_free()

func _add_kv_row(container: VBoxContainer, key: String, 
		val: Variant, on_delete: Callable, cat: String = "") -> void:
	var row := HBoxContainer.new()
	row.custom_minimum_size.y = 26
	row.set_meta("key", key)
	
	var c_lbl: Label
	if cat != "":
		c_lbl = Label.new(); c_lbl.text = cat
		c_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var k_lbl := Label.new(); k_lbl.text = key
	k_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var v_lbl := Label.new(); v_lbl.text = _val_to_text(val)
	v_lbl.custom_minimum_size.x = 120
	v_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT

	var del := Button.new(); del.text = "Delete"
	var key_copy := key
	del.pressed.connect(func(): on_delete.call(key_copy, row))
	
	if cat != "":
		row.set_meta("cat", cat)
		row.add_child(c_lbl)
	row.add_child(k_lbl)
	row.add_child(v_lbl)
	row.add_child(del)
	container.add_child(row)

func _replace_kv_row(container: VBoxContainer, key: String, val: Variant, cat: String = "") -> void:
	for child in container.get_children():
		if child is HBoxContainer:
			if child.get_meta("key") == key and cat == "":
				var v_lbl := child.get_child(1)
				if v_lbl is Label:
					v_lbl.text = _val_to_text(val)
				return
			elif child.get_meta("key") == key and child.get_meta("cat") == cat:
				var v_lbl := child.get_child(2)
				if v_lbl is Label:
					v_lbl.text = _val_to_text(val)
				return

# ---------- Helpers ----------
func _reset_ui() -> void:
	for le in [_id, _title, _role, _slot_input, _equip_key, _equip_val, _th_key]:
		if le: le.text = ""
	for sb in [_cost, _strength, _attack, _defense, _spot_m, _range_m, _morale, _speed_kph, _th_val]:
		if sb: sb.value = 0
	_slots.clear(); _reset_equip(); _thru.clear()
	for c in _slots_list.get_children(): c.queue_free()
	for c in _equip_list.get_children(): c.queue_free()
	for c in _th_list.get_children(): c.queue_free()
	if _category_ob.item_count > 0: _category_ob.select(-1)
	_select_size(UnitData.UnitSize.PLATOON)
	_select_move_profile(_default_move_profile())

func _reset_equip() -> void:
	_equip.clear()
	for cat in EquipCategory.keys():
		_equip[cat.to_lower()] = {}

func _default_move_profile() -> int:
	if typeof(TerrainBrush) != TYPE_NIL and "MoveProfile" in TerrainBrush:
		return int(TerrainBrush.MoveProfile.FOOT)
	return 0

func _parse_value(s: String) -> Variant:
	# Try int, then float, else string.
	if s.is_valid_int(): return int(s)
	if s.is_valid_float(): return float(s)
	return s

func _val_to_text(v: Variant) -> String:
	match typeof(v):
		TYPE_DICTIONARY, TYPE_ARRAY: return JSON.stringify(v)
		_: return str(v)

func _require_id(s: String) -> String:
	var idt := s.strip_edges()
	if idt != "": return idt
	return _slug(_title.text.strip_edges())

static func _slug(s: String) -> String:
	var out := ""
	for ch in s.to_lower():
		if ch.is_valid_identifier() or ch in ["-", "_"]:
			out += ch
		elif ch == " ":
			out += "_"
	return out

func _error(msg: String) -> String:
	_error_dlg.dialog_text = msg
	_error_dlg.popup_centered()
	return msg
