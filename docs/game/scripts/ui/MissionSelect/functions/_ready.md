# MissionSelect::_ready Function Reference

*Defined at:* `scripts/ui/MissionSelect.gd` (lines 40–58)</br>
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
```
