@tool
class_name OcMenuConfirmation
extends OcMenuWindow

## Confirmation Description (BBCode)
@export var description: String = ""

var _description_box: RichTextLabel

func _ready() -> void:
	super._ready()
	_description_box = %DialogText

func _process(dt: float) -> void:
	super._process(dt)
	_description_box.text = description
