# RadioResponsesSfx::_on_transmission_start Function Reference

*Defined at:* `scripts/radio/RadioSfx.gd` (lines 29–37)</br>
*Belongs to:* [RadioResponsesSfx](../../RadioResponsesSfx.md)

**Signature**

```gdscript
func _on_transmission_start(_callsign: String) -> void
```

## Source

```gdscript
func _on_transmission_start(_callsign: String) -> void:
	if transmission_noise_sound:
		noise_player.play()

	if transmission_start_sound:
		trigger_player.stream = transmission_start_sound
		trigger_player.play()
```
