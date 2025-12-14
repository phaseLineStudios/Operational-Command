# DocumentFace::_ready Function Reference

*Defined at:* `scripts/ui/DocumentFace.gd` (lines 20–36)</br>
*Belongs to:* [DocumentFace](../../DocumentFace.md)

**Signature**

```gdscript
func _ready() -> void
```

## Source

```gdscript
func _ready() -> void:
	# Setup page change sound player
	if not page_change_sounds.is_empty():
		_page_sound_player = AudioStreamPlayer.new()
		_page_sound_player.bus = "SFX"
		add_child(_page_sound_player)

	# Connect button signals
	if prev_button:
		prev_button.pressed.connect(_on_prev_pressed)
	if next_button:
		next_button.pressed.connect(_on_next_pressed)

	# Initial update
	update_page_indicator()
```
