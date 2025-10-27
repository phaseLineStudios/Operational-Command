class_name CounterConfigDialog
extends Window

## @experimental
## Dialog for creating unit counters with specified parameters

## Emitted when the user requests to create a counter
signal counter_create_requested(
	p_affiliation: MilSymbol.UnitAffiliation,
	p_type: MilSymbol.UnitType,
	p_size: MilSymbol.UnitSize,
	p_callsign: String
)

@onready var affiliation: OptionButton = %Affiliation
@onready var type: OptionButton = %Type
@onready var unit_size: OptionButton = %Size
@onready var callsign: LineEdit = %Callsign
@onready var close_btn: Button = %Close
@onready var create_btn: Button = %Create


func _ready() -> void:
	close_requested.connect(func(): hide())
	close_btn.pressed.connect(func(): hide())
	create_btn.pressed.connect(_on_create_pressed)

	_populate_affiliation()
	_populate_types()
	_populate_sizes()

	# Set default callsign
	callsign.text = "ALPHA"


func _populate_affiliation() -> void:
	affiliation.clear()
	for aff in MilSymbol.UnitAffiliation.keys():
		affiliation.add_item(aff)
	affiliation.selected = 0  # Default to FRIEND


func _populate_types() -> void:
	type.clear()
	for unit_type in MilSymbol.UnitType.keys():
		type.add_item(unit_type)
	type.selected = 0  # Default to INFANTRY


func _populate_sizes() -> void:
	unit_size.clear()
	for size in MilSymbol.UnitSize.keys():
		unit_size.add_item(size)
	unit_size.selected = 4  # Default to COMPANY


func _on_create_pressed() -> void:
	var selected_affiliation := affiliation.selected as MilSymbol.UnitAffiliation
	var selected_type := type.selected as MilSymbol.UnitType
	var selected_size := unit_size.selected as MilSymbol.UnitSize
	var selected_callsign := callsign.text.strip_edges().to_upper()

	if selected_callsign.is_empty():
		selected_callsign = "UNIT"

	counter_create_requested.emit(
		selected_affiliation, selected_type, selected_size, selected_callsign
	)

	hide()
