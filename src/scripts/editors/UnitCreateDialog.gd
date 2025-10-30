class_name UnitCreateDialog
extends Window
## Create/edit UnitData and save the unit.

## Emitted after a successful save.
signal unit_saved(unit: UnitData, path: String)
## Emitted when canceled.
signal canceled

## Dialog mode.
enum DialogMode { CREATE, EDIT }

var _mode: DialogMode = DialogMode.CREATE
var _working: UnitData
var _slots: Array[String] = []
var _equip := {}
var _thru := {}
var _cat_items: Array = []
var _ammo_spinners: Array[SpinBox] = []
var _ammo_keys: Array[String] = []

@onready var _id: LineEdit = %Id
@onready var _title: LineEdit = %Title
@onready var _role: LineEdit = %Role
@onready var _cost: SpinBox = %Cost
@onready var _strength: SpinBox = %Strength
@onready var _attack: SpinBox = %Attack
@onready var _defense: SpinBox = %Defense
@onready var _spot_m: SpinBox = %Spot
@onready var _range_m: SpinBox = %Range
@onready var _morale: SpinBox = %Morale
@onready var _speed_kph: SpinBox = %Speed
@onready var _is_engineer: CheckBox = %IsEngineer
@onready var _is_medical: CheckBox = %IsMedical

@onready var _icon_fr_preview: TextureRect = %IconPreview
@onready var _icon_eny_preview: TextureRect = %EnemyIconPreview
@onready var _icon_neu_preview: TextureRect = %NeutralIconPreview

@onready var _category_ob: OptionButton = %Category
@onready var _size_ob: OptionButton = %UnitSize
@onready var _type_ob: OptionButton = %UnitType
@onready var _move_ob: OptionButton = %MoveProfile

@onready var _slot_input: LineEdit = %SlotInput
@onready var _slot_add: Button = %SlotAdd
@onready var _slots_list: VBoxContainer = %SlotsVBox

@onready var _equip_cat: OptionButton = %EquipmentCategory
@onready var _equip_key: LineEdit = %EquipmentType
@onready var _equip_val: SpinBox = %EquipmentAmount
@onready var _equip_ammo_container: HBoxContainer = %EquipmentAmmoContainer
@onready var _equip_ammo: OptionButton = %EquipmentAmmo
@onready var _equip_add: Button = %EquipmentAdd
@onready var _equip_list: VBoxContainer = %EquipmentList
@onready var _ammo_container: GridContainer = %AmmoContainer

@onready var _th_key: LineEdit = %ThroughputType
@onready var _th_val: SpinBox = %ThroughputAmount
@onready var _th_add: Button = %ThroughputAdd
@onready var _th_list: VBoxContainer = %ThroughputList

@onready var _save_btn: Button = %Save
@onready var _cancel_btn: Button = %Close
@onready var _error_dlg: AcceptDialog = %ErrorDialog


func _ready() -> void:
	_populate_type()
	_populate_size()
	_populate_move_profile()
	_populate_categories()
	_populate_ammo()

	for cat in UnitData.EquipCategory.keys():
		_equip_cat.add_item(cat)

	for ammo in UnitData.AmmoTypes.keys():
		_equip_ammo.add_item(ammo)

	_equip_cat.item_selected.connect(
		func(idx: int):
			if idx == UnitData.EquipCategory.WEAPONS:
				_equip_ammo_container.visible = true
			else:
				_equip_ammo_container.visible = false
	)

	_slot_add.pressed.connect(_on_add_slot)
	_equip_add.pressed.connect(_on_add_equip)
	_th_add.pressed.connect(_on_add_throughput)

	_save_btn.pressed.connect(_on_save_pressed)
	_cancel_btn.pressed.connect(_on_cancel_pressed)
	close_requested.connect(_on_cancel_pressed)

	_size_ob.item_selected.connect(_generate_preview_icons)
	_type_ob.item_selected.connect(_generate_preview_icons)


## Open dialog (CREATE if unit == null).
## [param state] True to show, false to hide.
## [param unit] Optional, if supplied will edit that unit.
func show_dialog(state: bool, unit: UnitData = null) -> void:
	if not state:
		hide()
		_reset_ui()
		return
	_reset_ui()
	_mode = DialogMode.EDIT if unit != null else DialogMode.CREATE
	_working = (unit.duplicate(true) as UnitData) if unit != null else UnitData.new()
	_load_from_working()
	popup_centered_ratio(0.72)


## Load UI from working data.
func _load_from_working() -> void:
	if _mode == DialogMode.CREATE:
		if String(_working.role) == "":
			_working.role = "INF"
		if _working.allowed_slots.is_empty():
			_working.allowed_slots = ["INF"]
		if _working.size == null:
			_working.size = MilSymbol.UnitSize.PLATOON
		if _working.morale == 0.0:
			_working.morale = 0.9
		if _working.movement_profile == null:
			_working.movement_profile = _default_move_profile() as TerrainBrush.MoveProfile

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
	_is_engineer.set_pressed_no_signal(_working.isEngineer)
	_is_medical.set_pressed_no_signal(_working.isMedical)

	_select_size(_working.size)
	_select_type(_working.type)
	_select_move_profile(_working.movement_profile)
	_select_category(_working.unit_category)

	_slots.clear()
	for s in _working.allowed_slots:
		_add_slot_row(String(s))
	_slots = _working.allowed_slots.duplicate()

	_reset_equip()
	var eq := _working.equipment if (typeof(_working.equipment) == TYPE_DICTIONARY) else {}
	for raw_cat in eq.keys():
		var cat := String(raw_cat).to_lower()
		if not _equip.has(cat):
			_equip[cat] = {}
		var cat_dict: Variant = eq[raw_cat]
		if typeof(cat_dict) != TYPE_DICTIONARY:
			continue

		for k in cat_dict.keys():
			var entry: Variant = cat_dict[k]
			var count := 0
			var ammo := -1

			if typeof(entry) == TYPE_DICTIONARY:
				if entry.has("type"):
					count = int(entry["type"])
				elif entry.has("count"):
					count = int(entry["count"])
				else:
					count = int(entry)
				if entry.has("ammo"):
					ammo = int(entry["ammo"])
			else:
				count = int(entry)

			_add_kv_row(_equip_list, String(k), count, _on_delete_equip_row, cat, ammo)
			_equip[cat][String(k)] = {"type": count, "ammo": ammo}

	_thru.clear()
	for k in _working.throughput.keys():
		_add_kv_row(_th_list, String(k), _working.throughput[k], _on_delete_throughput_row)
		_thru[k] = _working.throughput[k]

	_load_ammo_from_working()


## Load ammo amounts from _working.ammo into the SpinBoxes.
func _load_ammo_from_working() -> void:
	var ammo_dict: Variant = _working.get("ammo")
	if typeof(ammo_dict) != TYPE_DICTIONARY:
		ammo_dict = {}

	for i in _ammo_spinners.size():
		var key_name := _ammo_keys[i]
		var sp := _ammo_spinners[i]
		var v := 0

		if ammo_dict.has(key_name):
			v = int(ammo_dict[key_name])
		else:
			var idx := int(UnitData.AmmoTypes[key_name])
			if ammo_dict.has(idx):
				v = int(ammo_dict[idx])

		sp.value = v


## Apply UI -> working data.
func _collect_into_working() -> void:
	_working.id = _require_id(_id.text)
	_working.title = _title.text.strip_edges()
	_working.role = _role.text.strip_edges()
	_working.cost = int(_cost.value)
	_working.strength = int(_strength.value)
	_working.state_strength = int(_strength.value)
	_working.attack = float(_attack.value)
	_working.defense = float(_defense.value)
	_working.spot_m = float(_spot_m.value)
	_working.range_m = float(_range_m.value)
	_working.morale = clamp(float(_morale.value), 0.0, 1.0)
	_working.speed_kph = float(_speed_kph.value)
	_working.isEngineer = _is_engineer.button_pressed
	_working.isMedical = _is_medical.button_pressed

	_working.type = int(_type_ob.get_selected_id()) as MilSymbol.UnitType
	_working.size = int(_size_ob.get_selected_id()) as MilSymbol.UnitSize
	_working.movement_profile = int(_move_ob.get_selected_id()) as TerrainBrush.MoveProfile

	_working.allowed_slots = _slots.duplicate()
	_working.equipment = _equip.duplicate()
	_working.throughput = _thru.duplicate()

	_collect_ammo_into_working()

	var cat_meta = _category_ob.get_item_metadata(_category_ob.get_selected())
	if typeof(cat_meta) == TYPE_DICTIONARY and cat_meta.has("res"):
		_working.unit_category = cat_meta["res"]


## Collect ammo amounts from SpinBoxes into _working.ammo.
func _collect_ammo_into_working() -> void:
	var out := {}
	for i in _ammo_spinners.size():
		var val := int(_ammo_spinners[i].value)
		out[_ammo_keys[i]] = val
	_working.ammunition = out


## Emit save signal.
func _on_save_pressed() -> void:
	var msg := _validate()
	if msg != "":
		return _error(msg)
	_collect_into_working()
	hide()
	_reset_ui()
	emit_signal("unit_saved", _working, "")


## Emit cancel signal.
func _on_cancel_pressed() -> void:
	hide()
	_reset_ui()
	emit_signal("canceled")


func _generate_preview_icons(_idx: int) -> void:
	var fr_icon := await MilSymbol.create_symbol(
		MilSymbol.UnitAffiliation.FRIEND,
		_type_ob.selected,
		MilSymbolConfig.Size.MEDIUM,
		_size_ob.selected
	)

	var eny_icon := await MilSymbol.create_symbol(
		MilSymbol.UnitAffiliation.ENEMY,
		_type_ob.selected,
		MilSymbolConfig.Size.MEDIUM,
		_size_ob.selected
	)
	var neu_icon := await MilSymbol.create_symbol(
		MilSymbol.UnitAffiliation.NEUTRAL,
		_type_ob.selected,
		MilSymbolConfig.Size.MEDIUM,
		_size_ob.selected
	)

	_icon_fr_preview.texture = fr_icon
	_icon_eny_preview.texture = eny_icon
	_icon_neu_preview.texture = neu_icon


## Validate fields
func _validate() -> String:
	if _id.text.strip_edges() == "":
		return _error("Unit ID is required.")
	if _title.text.strip_edges() == "":
		return _error("Title is required.")
	if _role.text.strip_edges() == "":
		return _error("Role is required.")
	if _slots.is_empty():
		return _error("At least one Allowed Slot is required.")
	if _category_ob.get_selected() < 0:
		return _error("Select a Category.")
	return ""


func _populate_type() -> void:
	_type_ob.clear()
	for type in MilSymbol.UnitType.keys():
		_type_ob.add_item(type)


## populate size optionbutton.
func _populate_size() -> void:
	_size_ob.clear()
	for echelon in MilSymbol.UnitSize.keys():
		_size_ob.add_item(echelon)
	_select_size(MilSymbol.UnitSize.PLATOON)


## Populate move profile option button.
func _populate_move_profile() -> void:
	_move_ob.clear()
	var mp = TerrainBrush.MoveProfile
	for mp_name in mp.keys():
		_move_ob.add_item(String(mp_name), int(mp[mp_name]))


## Populate editor categories.
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


## Populate Ammo
func _populate_ammo() -> void:
	for c in _ammo_container.get_children():
		c.queue_free()

	_ammo_spinners.clear()
	_ammo_keys.clear()

	for ammo_name in UnitData.AmmoTypes.keys():
		var lbl := Label.new()
		lbl.text = ammo_name

		var amt := SpinBox.new()
		amt.max_value = 20_000
		amt.value = 0
		amt.suffix = "rnds"

		_ammo_container.add_child(lbl)
		_ammo_container.add_child(amt)

		_ammo_keys.append(ammo_name)
		_ammo_spinners.append(amt)


## Select unit size.
func _select_size(v: int) -> void:
	for i in _size_ob.item_count:
		if _size_ob.get_item_id(i) == int(v):
			_size_ob.select(i)
			_generate_preview_icons(-1)
			return


## Select unit type.
func _select_type(v: int) -> void:
	for i in _type_ob.item_count:
		if _type_ob.get_item_id(i) == int(v):
			_type_ob.select(i)
			_generate_preview_icons(-1)
			return


## Select move profile.
func _select_move_profile(v: int) -> void:
	for i in _move_ob.item_count:
		if _move_ob.get_item_id(i) == int(v):
			_move_ob.select(i)
			return


## Select editor category.
func _select_category(cat: UnitCategoryData) -> void:
	if cat == null:
		return
	for i in _category_ob.item_count:
		var meta = _category_ob.get_item_metadata(i)
		if typeof(meta) == TYPE_DICTIONARY and meta.has("id"):
			if String(meta["id"]) == String(cat.get("id") if cat.has_method("get") else cat.id):
				_category_ob.select(i)
				return


## Add slot to list.
func _on_add_slot() -> void:
	var s := _slot_input.text.strip_edges().to_upper()
	if s == "":
		return
	if s in _slots:
		return
	_slots.append(s)
	_add_slot_row(s)
	_slot_input.clear()


## Append new slot row to list.
func _add_slot_row(s: String) -> void:
	var row := HBoxContainer.new()
	row.custom_minimum_size.y = 26
	row.set_meta("slot", s)

	var lbl := Label.new()
	lbl.text = s
	lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	var del := Button.new()
	del.text = "Delete"
	del.pressed.connect(
		func():
			_slots.erase(row.get_meta("slot"))
			row.queue_free()
	)

	row.add_child(lbl)
	row.add_child(del)
	_slots_list.add_child(row)


## Add equipment to list.
func _on_add_equip() -> void:
	var c := _equip_cat.selected as UnitData.EquipCategory
	var c_str := UnitData.EquipCategory.keys()[c] as String
	var k := _equip_key.text.strip_edges()
	var v := int(_equip_val.value)
	var a: int = -1
	if c == UnitData.EquipCategory.WEAPONS:
		a = _equip_ammo.selected as UnitData.AmmoTypes
	if k == "":
		return
	if _equip[c_str.to_lower()].has(k):
		_replace_kv_row(_equip_list, k, v, c_str.to_lower(), a)
	else:
		_add_kv_row(_equip_list, k, v, _on_delete_equip_row, c_str.to_lower(), a)
	_equip[c_str.to_lower()][k] = {"type": v, "ammo": a}
	_equip_key.text = ""
	_equip_val.value = 0


## Delete equipment from list
func _on_delete_equip_row(key: String, row: HBoxContainer) -> void:
	var cat := String(row.get_meta("cat", ""))
	if cat != "" and _equip.has(cat):
		_equip[cat].erase(key)
	else:
		_equip.erase(key)
	row.queue_free()


## Add throughput to list.
func _on_add_throughput() -> void:
	var k := _th_key.text.strip_edges()
	var v := float(_th_val.value)
	if k == "":
		return
	if _thru.has(k):
		_replace_kv_row(_th_list, k, v)
	else:
		_add_kv_row(_th_list, k, v, _on_delete_throughput_row)
	_thru[k] = v
	_th_key.clear()
	_th_val.value = 0.0


## Delete throughput from list.
func _on_delete_throughput_row(key: String, row: HBoxContainer) -> void:
	_thru.erase(key)
	row.queue_free()


## Add a key-value row (optional category row).
## [param container] List container.
## [param key] Key to add.
## [param val] Value of key.
## [param on_delete] On delete callback.
## [param cat] optional category.
## [param ammo] optional Ammo Category.
func _add_kv_row(
	container: VBoxContainer,
	key: String,
	val: Variant,
	on_delete: Callable,
	cat: String = "",
	ammo = -1
) -> void:
	var row := HBoxContainer.new()
	row.custom_minimum_size.y = 26
	row.set_meta("key", key)

	var c_lbl: Label
	if cat != "":
		c_lbl = Label.new()
		c_lbl.text = cat
		c_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var k_lbl := Label.new()
	k_lbl.text = key
	k_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var a_lbl := Label.new()
	a_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	if ammo != -1:
		a_lbl.text = UnitData.AmmoTypes.keys()[ammo]
	var v_lbl := Label.new()
	v_lbl.text = _val_to_text(val)
	v_lbl.custom_minimum_size.x = 120
	v_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT

	var del := Button.new()
	del.text = "Delete"
	var key_copy := key
	del.pressed.connect(func(): on_delete.call(key_copy, row))

	if cat != "":
		row.set_meta("cat", cat)
		row.add_child(c_lbl)
	row.add_child(k_lbl)
	row.add_child(a_lbl)
	row.add_child(v_lbl)
	row.add_child(del)
	container.add_child(row)


## Replace a key-value row (optional category row).
## [param container] List container.
## [param key] Key to add.
## [param val] Value of key.
## [param cat] optional category.
## [param ammo] optional Ammo Category.
func _replace_kv_row(
	container: VBoxContainer, key: String, val: Variant, cat: String = "", ammo = -1
) -> void:
	for child in container.get_children():
		if child is HBoxContainer:
			if child.get_meta("key") == key and cat == "" and ammo == -1:
				var v_lbl := child.get_child(1)
				if v_lbl is Label:
					v_lbl.text = _val_to_text(val)
				return
			elif child.get_meta("key") == key and cat == "" and ammo > -1:
				var a_lbl := child.get_child(1)
				if a_lbl is Label:
					a_lbl.text = UnitData.AmmoTypes.keys()[ammo]
				var v_lbl := child.get_child(2)
				if v_lbl is Label:
					v_lbl.text = _val_to_text(val)
				return
			elif child.get_meta("key") == key and child.get_meta("cat") == cat and ammo == -1:
				var v_lbl := child.get_child(2)
				if v_lbl is Label:
					v_lbl.text = _val_to_text(val)
				return
			elif child.get_meta("key") == key and child.get_meta("cat") == cat and ammo > -1:
				var a_lbl := child.get_child(2)
				if a_lbl is Label:
					a_lbl.text = UnitData.AmmoTypes.keys()[ammo]
				var v_lbl := child.get_child(3)
				if v_lbl is Label:
					v_lbl.text = _val_to_text(val)
				return


## Reset UI elements
func _reset_ui() -> void:
	for le in [_id, _title, _role, _slot_input, _equip_key, _th_key]:
		if le:
			le.text = ""

	for sb in [
		_cost,
		_strength,
		_attack,
		_defense,
		_spot_m,
		_range_m,
		_morale,
		_speed_kph,
		_equip_val,
		_th_val
	]:
		if sb:
			sb.value = 0
	_slots.clear()
	_reset_equip()
	_thru.clear()
	for c in _slots_list.get_children():
		c.queue_free()
	for c in _equip_list.get_children():
		c.queue_free()
	for c in _th_list.get_children():
		c.queue_free()
	if _category_ob.item_count > 0:
		_category_ob.select(-1)
	for sp in _ammo_spinners:
		if sp:
			sp.value = 0
	_select_size(MilSymbol.UnitSize.PLATOON)
	_select_type(MilSymbol.UnitType.INFANTRY)
	_select_move_profile(_default_move_profile())
	_equip_cat.select(UnitData.EquipCategory.VEHICLES)
	
	_equip_ammo_container.visible = false
	_is_engineer.set_pressed_no_signal(false)
	_is_medical.set_pressed_no_signal(false)


## Reset equipment dictionary.
func _reset_equip() -> void:
	_equip.clear()
	for cat in UnitData.EquipCategory.keys():
		_equip[cat.to_lower()] = {}


## Return default move profile.
func _default_move_profile() -> int:
	if typeof(TerrainBrush) != TYPE_NIL and "MoveProfile" in TerrainBrush:
		return int(TerrainBrush.MoveProfile.FOOT)
	return 0


## Convert any value to string.
func _val_to_text(v: Variant) -> String:
	match typeof(v):
		TYPE_DICTIONARY, TYPE_ARRAY:
			return JSON.stringify(v)
		_:
			return str(v)


## Require a unit id.
func _require_id(s: String) -> String:
	var idt := s.strip_edges()
	if idt != "":
		return idt
	return _slug(_title.text.strip_edges())


## Show error dialog.
## [param msg] Error message.
## [return] Same as [param msg].
func _error(msg: String) -> String:
	_error_dlg.dialog_text = msg
	_error_dlg.popup_centered()
	return msg


## Create a id from string.
## [param s] string to create id from.
## [return] id string.
static func _slug(s: String) -> String:
	var out := ""
	for ch in s.to_lower():
		if ch.is_valid_identifier() or ch in ["-", "_"]:
			out += ch
		elif ch == " ":
			out += "_"
	return out
