extends Control
## Loading screen overlay that appears during mission initialization.
##
## Displays a loading indicator and message while the simulation is in INIT state.
## Automatically hides when the simulation transitions to any other state.

var _scenario: ScenarioData = Game.current_scenario

@onready var _card_title: Label = %CardTitle
@onready var _card_desc: RichTextLabel = %CardDesc
@onready var _card_image: TextureRect = %CardImage
@onready var _label: Label = %LoadingLabel


func _ready() -> void:
	# Start visible
	visible = true
	set_card_details()


## Set scenario details in card.
func set_card_details() -> void:
	if _scenario == null:
		return
	_card_title.text = _scenario.title
	_card_desc.text = _scenario.description
	_card_image.texture = _scenario.preview


## Show the loading screen with optional custom message
func show_loading(
	scenario: ScenarioData = Game.current_scenario, message: String = "Loading..."
) -> void:
	_scenario = scenario
	set_card_details()

	if _label:
		_label.text = message
	visible = true


## Hide the loading screen
func hide_loading() -> void:
	visible = false
