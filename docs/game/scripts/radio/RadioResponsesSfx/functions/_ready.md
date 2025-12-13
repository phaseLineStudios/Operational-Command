# RadioResponsesSfx::_ready Function Reference

*Defined at:* `scripts/radio/RadioSfx.gd` (lines 17–28)</br>
*Belongs to:* [RadioResponsesSfx](../../RadioResponsesSfx.md)

**Signature**

```gdscript
func _ready() -> void
```

## Source

```gdscript
func _ready() -> void:
	if not unit_responses_node:
		LogService.warning("Failed to find unit responses node", "RadioResponsesSfx.gd")
		return

	if transmission_noise_sound:
		noise_player.stream = transmission_noise_sound

	unit_responses_node.transmission_start.connect(_on_transmission_start)
	unit_responses_node.transmission_end.connect(_on_transmission_end)
```
