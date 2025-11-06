# UnitCreateDialog Class Reference

*File:* `scripts/editors/UnitCreateDialog.gd`
*Class name:* `UnitCreateDialog`
*Inherits:* `Window`

## Synopsis

```gdscript
class_name UnitCreateDialog
extends Window
```

## Brief

Create/edit UnitData and save the unit.

## Detailed Description

Add a key-value row (optional category row).
`container` List container.
`key` Key to add.
`val` Value of key.
`on_delete` On delete callback.
`cat` optional category.
`ammo` optional Ammo Category.

Replace a key-value row (optional category row).
`container` List container.
`key` Key to add.
`val` Value of key.
`cat` optional category.
`ammo` optional Ammo Category.

## Public Member Functions

- [`func _ready() -> void`](UnitCreateDialog/functions/_ready.md)
- [`func show_dialog(state: bool, unit: UnitData = null) -> void`](UnitCreateDialog/functions/show_dialog.md) — Open dialog (CREATE if unit == null).
- [`func _load_from_working() -> void`](UnitCreateDialog/functions/_load_from_working.md) — Load UI from working data.
- [`func _load_ammo_from_working() -> void`](UnitCreateDialog/functions/_load_ammo_from_working.md) — Load ammo amounts from _working.ammo into the SpinBoxes.
- [`func _collect_into_working() -> void`](UnitCreateDialog/functions/_collect_into_working.md) — Apply UI -> working data.
- [`func _collect_ammo_into_working() -> void`](UnitCreateDialog/functions/_collect_ammo_into_working.md) — Collect ammo amounts from SpinBoxes into _working.ammo.
- [`func _on_save_pressed() -> void`](UnitCreateDialog/functions/_on_save_pressed.md) — Emit save signal.
- [`func _on_cancel_pressed() -> void`](UnitCreateDialog/functions/_on_cancel_pressed.md) — Emit cancel signal.
- [`func _generate_preview_icons(_idx: int) -> void`](UnitCreateDialog/functions/_generate_preview_icons.md)
- [`func _validate() -> String`](UnitCreateDialog/functions/_validate.md) — Validate fields
- [`func _populate_type() -> void`](UnitCreateDialog/functions/_populate_type.md)
- [`func _populate_size() -> void`](UnitCreateDialog/functions/_populate_size.md) — populate size optionbutton.
- [`func _populate_move_profile() -> void`](UnitCreateDialog/functions/_populate_move_profile.md) — Populate move profile option button.
- [`func _populate_categories() -> void`](UnitCreateDialog/functions/_populate_categories.md) — Populate editor categories.
- [`func _populate_ammo() -> void`](UnitCreateDialog/functions/_populate_ammo.md) — Populate Ammo
- [`func _select_size(v: int) -> void`](UnitCreateDialog/functions/_select_size.md) — Select unit size.
- [`func _select_type(v: int) -> void`](UnitCreateDialog/functions/_select_type.md) — Select unit type.
- [`func _select_move_profile(v: int) -> void`](UnitCreateDialog/functions/_select_move_profile.md) — Select move profile.
- [`func _select_category(cat: UnitCategoryData) -> void`](UnitCreateDialog/functions/_select_category.md) — Select editor category.
- [`func _on_add_slot() -> void`](UnitCreateDialog/functions/_on_add_slot.md) — Add slot to list.
- [`func _add_slot_row(s: String) -> void`](UnitCreateDialog/functions/_add_slot_row.md) — Append new slot row to list.
- [`func _on_add_equip() -> void`](UnitCreateDialog/functions/_on_add_equip.md) — Add equipment to list.
- [`func _on_delete_equip_row(key: String, row: HBoxContainer) -> void`](UnitCreateDialog/functions/_on_delete_equip_row.md) — Delete equipment from list
- [`func _on_add_throughput() -> void`](UnitCreateDialog/functions/_on_add_throughput.md) — Add throughput to list.
- [`func _on_delete_throughput_row(key: String, row: HBoxContainer) -> void`](UnitCreateDialog/functions/_on_delete_throughput_row.md) — Delete throughput from list.
- [`func _reset_ui() -> void`](UnitCreateDialog/functions/_reset_ui.md) — Reset UI elements
- [`func _reset_equip() -> void`](UnitCreateDialog/functions/_reset_equip.md) — Reset equipment dictionary.
- [`func _default_move_profile() -> int`](UnitCreateDialog/functions/_default_move_profile.md) — Return default move profile.
- [`func _val_to_text(v: Variant) -> String`](UnitCreateDialog/functions/_val_to_text.md) — Convert any value to string.
- [`func _require_id(s: String) -> String`](UnitCreateDialog/functions/_require_id.md) — Require a unit id.
- [`func _error(msg: String) -> String`](UnitCreateDialog/functions/_error.md) — Show error dialog.
- [`func _slug(s: String) -> String`](UnitCreateDialog/functions/_slug.md) — Create a id from string.

## Public Attributes

- `DialogMode _mode`
- `UnitData _working`
- `Array[String] _slots`
- `Array _cat_items`
- `Array[SpinBox] _ammo_spinners`
- `Array[String] _ammo_keys`
- `LineEdit _id`
- `LineEdit _title`
- `LineEdit _role`
- `SpinBox _cost`
- `SpinBox _strength`
- `SpinBox _attack`
- `SpinBox _defense`
- `SpinBox _spot_m`
- `SpinBox _range_m`
- `SpinBox _morale`
- `SpinBox _speed_kph`
- `CheckBox _is_engineer`
- `CheckBox _is_medical`
- `TextureRect _icon_fr_preview`
- `TextureRect _icon_eny_preview`
- `TextureRect _icon_neu_preview`
- `OptionButton _category_ob`
- `OptionButton _size_ob`
- `OptionButton _type_ob`
- `OptionButton _move_ob`
- `LineEdit _slot_input`
- `Button _slot_add`
- `VBoxContainer _slots_list`
- `OptionButton _equip_cat`
- `LineEdit _equip_key`
- `SpinBox _equip_val`
- `HBoxContainer _equip_ammo_container`
- `OptionButton _equip_ammo`
- `Button _equip_add`
- `VBoxContainer _equip_list`
- `GridContainer _ammo_container`
- `LineEdit _th_key`
- `SpinBox _th_val`
- `Button _th_add`
- `VBoxContainer _th_list`
- `Button _save_btn`
- `Button _cancel_btn`
- `AcceptDialog _error_dlg`
- `Label c_lbl`

## Signals

- `signal unit_saved(unit: UnitData, path: String)` — Emitted after a successful save.
- `signal canceled` — Emitted when canceled.

## Enumerations

- `enum DialogMode` — Dialog mode.

## Member Function Documentation

### _ready

```gdscript
func _ready() -> void
```

### show_dialog

```gdscript
func show_dialog(state: bool, unit: UnitData = null) -> void
```

Open dialog (CREATE if unit == null).
`state` True to show, false to hide.
`unit` Optional, if supplied will edit that unit.

### _load_from_working

```gdscript
func _load_from_working() -> void
```

Load UI from working data.

### _load_ammo_from_working

```gdscript
func _load_ammo_from_working() -> void
```

Load ammo amounts from _working.ammo into the SpinBoxes.

### _collect_into_working

```gdscript
func _collect_into_working() -> void
```

Apply UI -> working data.

### _collect_ammo_into_working

```gdscript
func _collect_ammo_into_working() -> void
```

Collect ammo amounts from SpinBoxes into _working.ammo.

### _on_save_pressed

```gdscript
func _on_save_pressed() -> void
```

Emit save signal.

### _on_cancel_pressed

```gdscript
func _on_cancel_pressed() -> void
```

Emit cancel signal.

### _generate_preview_icons

```gdscript
func _generate_preview_icons(_idx: int) -> void
```

### _validate

```gdscript
func _validate() -> String
```

Validate fields

### _populate_type

```gdscript
func _populate_type() -> void
```

### _populate_size

```gdscript
func _populate_size() -> void
```

populate size optionbutton.

### _populate_move_profile

```gdscript
func _populate_move_profile() -> void
```

Populate move profile option button.

### _populate_categories

```gdscript
func _populate_categories() -> void
```

Populate editor categories.

### _populate_ammo

```gdscript
func _populate_ammo() -> void
```

Populate Ammo

### _select_size

```gdscript
func _select_size(v: int) -> void
```

Select unit size.

### _select_type

```gdscript
func _select_type(v: int) -> void
```

Select unit type.

### _select_move_profile

```gdscript
func _select_move_profile(v: int) -> void
```

Select move profile.

### _select_category

```gdscript
func _select_category(cat: UnitCategoryData) -> void
```

Select editor category.

### _on_add_slot

```gdscript
func _on_add_slot() -> void
```

Add slot to list.

### _add_slot_row

```gdscript
func _add_slot_row(s: String) -> void
```

Append new slot row to list.

### _on_add_equip

```gdscript
func _on_add_equip() -> void
```

Add equipment to list.

### _on_delete_equip_row

```gdscript
func _on_delete_equip_row(key: String, row: HBoxContainer) -> void
```

Delete equipment from list

### _on_add_throughput

```gdscript
func _on_add_throughput() -> void
```

Add throughput to list.

### _on_delete_throughput_row

```gdscript
func _on_delete_throughput_row(key: String, row: HBoxContainer) -> void
```

Delete throughput from list.

### _reset_ui

```gdscript
func _reset_ui() -> void
```

Reset UI elements

### _reset_equip

```gdscript
func _reset_equip() -> void
```

Reset equipment dictionary.

### _default_move_profile

```gdscript
func _default_move_profile() -> int
```

Return default move profile.

### _val_to_text

```gdscript
func _val_to_text(v: Variant) -> String
```

Convert any value to string.

### _require_id

```gdscript
func _require_id(s: String) -> String
```

Require a unit id.

### _error

```gdscript
func _error(msg: String) -> String
```

Show error dialog.
`msg` Error message.
[return] Same as `msg`.

### _slug

```gdscript
func _slug(s: String) -> String
```

Create a id from string.
`s` string to create id from.
[return] id string.

## Member Data Documentation

### _mode

```gdscript
var _mode: DialogMode
```

### _working

```gdscript
var _working: UnitData
```

### _slots

```gdscript
var _slots: Array[String]
```

### _cat_items

```gdscript
var _cat_items: Array
```

### _ammo_spinners

```gdscript
var _ammo_spinners: Array[SpinBox]
```

### _ammo_keys

```gdscript
var _ammo_keys: Array[String]
```

### _id

```gdscript
var _id: LineEdit
```

### _title

```gdscript
var _title: LineEdit
```

### _role

```gdscript
var _role: LineEdit
```

### _cost

```gdscript
var _cost: SpinBox
```

### _strength

```gdscript
var _strength: SpinBox
```

### _attack

```gdscript
var _attack: SpinBox
```

### _defense

```gdscript
var _defense: SpinBox
```

### _spot_m

```gdscript
var _spot_m: SpinBox
```

### _range_m

```gdscript
var _range_m: SpinBox
```

### _morale

```gdscript
var _morale: SpinBox
```

### _speed_kph

```gdscript
var _speed_kph: SpinBox
```

### _is_engineer

```gdscript
var _is_engineer: CheckBox
```

### _is_medical

```gdscript
var _is_medical: CheckBox
```

### _icon_fr_preview

```gdscript
var _icon_fr_preview: TextureRect
```

### _icon_eny_preview

```gdscript
var _icon_eny_preview: TextureRect
```

### _icon_neu_preview

```gdscript
var _icon_neu_preview: TextureRect
```

### _category_ob

```gdscript
var _category_ob: OptionButton
```

### _size_ob

```gdscript
var _size_ob: OptionButton
```

### _type_ob

```gdscript
var _type_ob: OptionButton
```

### _move_ob

```gdscript
var _move_ob: OptionButton
```

### _slot_input

```gdscript
var _slot_input: LineEdit
```

### _slot_add

```gdscript
var _slot_add: Button
```

### _slots_list

```gdscript
var _slots_list: VBoxContainer
```

### _equip_cat

```gdscript
var _equip_cat: OptionButton
```

### _equip_key

```gdscript
var _equip_key: LineEdit
```

### _equip_val

```gdscript
var _equip_val: SpinBox
```

### _equip_ammo_container

```gdscript
var _equip_ammo_container: HBoxContainer
```

### _equip_ammo

```gdscript
var _equip_ammo: OptionButton
```

### _equip_add

```gdscript
var _equip_add: Button
```

### _equip_list

```gdscript
var _equip_list: VBoxContainer
```

### _ammo_container

```gdscript
var _ammo_container: GridContainer
```

### _th_key

```gdscript
var _th_key: LineEdit
```

### _th_val

```gdscript
var _th_val: SpinBox
```

### _th_add

```gdscript
var _th_add: Button
```

### _th_list

```gdscript
var _th_list: VBoxContainer
```

### _save_btn

```gdscript
var _save_btn: Button
```

### _cancel_btn

```gdscript
var _cancel_btn: Button
```

### _error_dlg

```gdscript
var _error_dlg: AcceptDialog
```

### c_lbl

```gdscript
var c_lbl: Label
```

## Signal Documentation

### unit_saved

```gdscript
signal unit_saved(unit: UnitData, path: String)
```

Emitted after a successful save.

### canceled

```gdscript
signal canceled
```

Emitted when canceled.

## Enumeration Type Documentation

### DialogMode

```gdscript
enum DialogMode
```

Dialog mode.
