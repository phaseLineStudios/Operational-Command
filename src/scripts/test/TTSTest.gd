class_name TTSTest
extends Control
## Test TTS Service.

@onready var model_input: OptionButton = %Model
@onready var text_input: TextEdit = %Text
@onready var submit_btn: Button = %Submit

func _ready() -> void:
	for mdl in TTSService.Model.keys():
		model_input.add_item(mdl)
		
	model_input.select(0)
	submit_btn.pressed.connect(_on_submit)

func _on_submit() -> void:
	if not TTSService.is_ready():
		LogService.warning("TTS Service not ready.", "TTSTest.gd:18")
		return
	
	var ok := TTSService.set_model(model_input.selected as TTSService.Model)
	if not ok:
		return
		
	ok = TTSService.say(text_input.text.strip_edges())
	if not ok:
		LogService.warning("Failed to send TTS")
