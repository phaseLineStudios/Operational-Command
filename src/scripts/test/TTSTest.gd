class_name TTSTest
extends Control
## Test TTS Service.

var _current_model := -1

@onready var model_input: OptionButton = %Model
@onready var text_input: TextEdit = %Text
@onready var submit_btn: Button = %Submit
@onready var radio_player: AudioStreamPlayer = %RadioPlayer


func _ready() -> void:
	for mdl in TTSService.Model.keys():
		model_input.add_item(mdl)
	model_input.select(TTSService.model)
	_current_model = TTSService.model

	submit_btn.pressed.connect(_on_submit)
	TTSService.stream_ready.connect(_on_stream_ready)

	if TTSService.get_stream() != null:
		_on_stream_ready(TTSService.get_stream())


func _on_submit() -> void:
	if not TTSService.is_ready():
		LogService.warning("TTS Service not ready.", "TTSTest.gd:18")
		return

	var ok := TTSService.say(text_input.text.strip_edges())
	if not ok:
		LogService.warning("Failed to send TTS")


func _on_stream_ready(stream: AudioStreamGenerator) -> void:
	radio_player.stream = stream
	radio_player.play()
	TTSService.register_playback(radio_player.get_stream_playback() as AudioStreamGeneratorPlayback)
