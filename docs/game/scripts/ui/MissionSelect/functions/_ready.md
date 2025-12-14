# MissionSelect::_ready Function Reference

*Defined at:* `scripts/ui/MissionSelect.gd` (lines 54–80)</br>
*Belongs to:* [MissionSelect](../../MissionSelect.md)

**Signature**

```gdscript
func _ready() -> void
```

## Description

Build UI, load map, place pins, hook resizes.

## Source

```gdscript
func _ready() -> void:
	if AudioManager.get_current_music() != AudioManager.main_menu_music:
		if not AudioManager.is_music_playing():
			AudioManager.play_music(AudioManager.main_menu_music)
		else:
			AudioManager.crossfade_to(AudioManager.main_menu_music, 0.5)

	_btn_back.pressed.connect(_on_back_pressed)
	_load_campaign_and_map()
	await get_tree().process_frame
	_build_pins()

	_click_catcher.gui_input.connect(_on_backdrop_gui_input)
	if not resized.is_connected(_update_pin_positions):
		resized.connect(_update_pin_positions)
	if not _container.resized.is_connected(_update_pin_positions):
		_container.resized.connect(_update_pin_positions)
	if not _map_rect.resized.is_connected(_update_pin_positions):
		_map_rect.resized.connect(_update_pin_positions)
	if not _card_start.pressed.is_connected(_on_start_pressed):
		_card_start.pressed.connect(_on_start_pressed)
	if not _card_close.pressed.is_connected(_close_card):
		_card_close.pressed.connect(_close_card)
	if not _pins_layer.draw.is_connected(_on_pins_layer_draw):
		_pins_layer.draw.connect(_on_pins_layer_draw)
```
