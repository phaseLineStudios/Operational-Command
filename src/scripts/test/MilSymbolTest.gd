extends Control

## Test script for MilSymbol generator
## Demonstrates how to create and display military symbols

## Grid layout settings
const SYMBOLS_PER_ROW: int = 4
const SYMBOL_SPACING: int = 150

var config: MilSymbolConfig
var generator: MilSymbol

@onready var u_type: OptionButton = %Type
@onready var u_size: OptionButton = %Size
@onready var u_modifier_1: OptionButton = %Modifier1
@onready var u_modifier_2: OptionButton = %Modifier2
@onready var u_designation: LineEdit = %Designation
@onready var u_status: OptionButton = %Status
@onready var u_reinforced_reduced: OptionButton = %ReinforcedReduced
@onready var u_frame: CheckBox = %Frame
@onready var refresh_btn: Button = %Refresh

@onready var fr_preview := %FRPreview
@onready var eny_preview := %ENYPreview
@onready var neu_preview := %NEUPreview
@onready var unk_preview := %UNKPreview

func _ready() -> void:
	config = MilSymbolConfig.create_default()
	config.size = MilSymbolConfig.Size.MEDIUM
	generator = MilSymbol.new(config)
	
	_refresh_options()
	
	u_type.item_selected.connect(func(_idx: int): _generate_symbols())
	u_size.item_selected.connect(func(_idx: int): _generate_symbols())
	u_modifier_1.item_selected.connect(func(_idx: int): _generate_symbols())
	u_modifier_2.item_selected.connect(func(_idx: int): _generate_symbols())
	u_status.item_selected.connect(func(_idx: int): _generate_symbols())
	u_reinforced_reduced.item_selected.connect(func(_idx: int): _generate_symbols())
	u_frame.pressed.connect(func(): _generate_symbols())
	refresh_btn.pressed.connect(func(): _on_refresh())
	
	_generate_symbols()

## Handle Enter for designation and arrow-key selection for focused OptionButtons.
func _input(event: InputEvent) -> void:
	if not (event is InputEventKey and event.pressed and not event.echo):
		return

	if u_designation.has_focus() and event.keycode == KEY_ENTER:
		_generate_symbols()
		accept_event()
		return

	var focused := get_viewport().gui_get_focus_owner()
	if not (focused is OptionButton):
		return

	if event.is_action_pressed("ui_up") or event.is_action_pressed("ui_left"):
		_change_option_selection(focused, -1)
		accept_event()
	elif event.is_action_pressed("ui_down") or event.is_action_pressed("ui_right"):
		_change_option_selection(focused, +1)
		accept_event()


## Increment/decrement selection on an OptionButton and emit item_selected.
## [param ob] The OptionButton to change.
## [param delta] +1 to move down/right, -1 to move up/left.
func _change_option_selection(ob: OptionButton, delta: int) -> void:
	var count := ob.get_item_count()
	if count <= 0:
		return
	var new_idx := clampi(ob.selected + delta, 0, count - 1)
	if new_idx == ob.selected:
		return
	ob.select(new_idx)
	ob.emit_signal("item_selected", new_idx)

## Generate all test symbols and display them in a grid
func _generate_symbols() -> void:
	if not u_frame.button_pressed:
		fr_preview.modulate = Color.WHITE
		fr_preview.texture = await generator.generate(
			MilSymbol.UnitAffiliation.FRIEND,
			u_type.selected,
			u_size.selected,
			u_designation.text
		)
		eny_preview.modulate = Color.WHITE
		eny_preview.texture = await generator.generate(
			MilSymbol.UnitAffiliation.ENEMY,
			u_type.selected,
			u_size.selected,
			u_designation.text
		)
		neu_preview.modulate = Color.WHITE
		neu_preview.texture = await generator.generate(
			MilSymbol.UnitAffiliation.NEUTRAL,
			u_type.selected,
			u_size.selected,
			u_designation.text
		)
		unk_preview.modulate = Color.WHITE
		unk_preview.texture = await generator.generate(
			MilSymbol.UnitAffiliation.UNKNOWN,
			u_type.selected,
			u_size.selected,
			u_designation.text
		)
	else:
		var frame_colors := MilSymbolConfig.get_frame_colors()
		fr_preview.modulate = frame_colors[MilSymbol.UnitAffiliation.FRIEND]
		fr_preview.texture = await MilSymbol.create_frame_symbol(
			MilSymbol.UnitAffiliation.FRIEND,
			u_type.selected,
			MilSymbolConfig.Size.MEDIUM,
			u_size.selected,
			u_designation.text
		)
		eny_preview.modulate = frame_colors[MilSymbol.UnitAffiliation.ENEMY]
		eny_preview.texture = await MilSymbol.create_frame_symbol(
			MilSymbol.UnitAffiliation.ENEMY,
			u_type.selected,
			MilSymbolConfig.Size.MEDIUM,
			u_size.selected,
			u_designation.text
		)
		neu_preview.modulate = frame_colors[MilSymbol.UnitAffiliation.NEUTRAL]
		neu_preview.texture = await MilSymbol.create_frame_symbol(
			MilSymbol.UnitAffiliation.NEUTRAL,
			u_type.selected,
			MilSymbolConfig.Size.MEDIUM,
			u_size.selected,
			u_designation.text
		)
		unk_preview.modulate = frame_colors[MilSymbol.UnitAffiliation.UNKNOWN]
		unk_preview.texture = await MilSymbol.create_frame_symbol(
			MilSymbol.UnitAffiliation.UNKNOWN,
			u_type.selected,
			MilSymbolConfig.Size.MEDIUM,
			u_size.selected,
			u_designation.text
		)
	generator.cleanup()


## Called when refresh button is clicked.
func _on_refresh() -> void:
	_refresh_options()
	_generate_symbols()


## Refreshes option buttons.
func _refresh_options() -> void:
	var u_type_val := u_type.selected
	var u_size_val := u_size.selected
	var u_modifier_1_val := u_modifier_1.selected
	var u_modifier_2_val := u_modifier_2.selected
	var u_status_val := u_status.selected
	var u_reinforced_reduced_val := u_reinforced_reduced.selected
	
	u_type.clear()
	for type_str in MilSymbol.UnitType.keys():
		u_type.add_item(type_str)
	u_type.select(u_type_val)
	
	u_size.clear()
	for size_str in MilSymbol.UnitSize.keys():
		u_size.add_item(size_str)
	u_size.select(u_size_val)
	
	u_modifier_1.clear()
	u_modifier_1.disabled = true
	u_modifier_1.select(u_modifier_1_val)
	
	u_modifier_2.clear()
	u_modifier_2.disabled = true
	u_modifier_2.select(u_modifier_2_val)
	
	u_status.clear()
	u_status.disabled = true
	u_status.select(u_status_val)
	
	u_reinforced_reduced.clear()
	u_reinforced_reduced.disabled = true
	u_reinforced_reduced.select(u_reinforced_reduced_val)
