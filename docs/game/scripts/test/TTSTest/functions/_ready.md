# TTSTest::_ready Function Reference

*Defined at:* `scripts/test/TTSTest.gd` (lines 13–25)</br>
*Belongs to:* [TTSTest](../../TTSTest.md)

**Signature**

```gdscript
func _ready() -> void
```

## Source

```gdscript
func _ready() -> void:
	for mdl in TTSService.Model.keys():
		model_input.add_item(mdl)
	model_input.select(TTSService.model)
	_current_model = TTSService.model

	submit_btn.pressed.connect(_on_submit)
	TTSService.stream_ready.connect(_on_stream_ready)

	if TTSService.get_stream() != null:
		_on_stream_ready(TTSService.get_stream())
```
