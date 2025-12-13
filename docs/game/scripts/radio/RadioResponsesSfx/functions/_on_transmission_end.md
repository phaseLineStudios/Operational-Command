# RadioResponsesSfx::_on_transmission_end Function Reference

*Defined at:* `scripts/radio/RadioSfx.gd` (lines 38–44)</br>
*Belongs to:* [RadioResponsesSfx](../../RadioResponsesSfx.md)

**Signature**

```gdscript
func _on_transmission_end(_callsign: String) -> void
```

## Source

```gdscript
func _on_transmission_end(_callsign: String) -> void:
	if transmission_noise_sound:
		noise_player.stop()

	if transmission_end_sound:
		trigger_player.stream = transmission_end_sound
		trigger_player.play()
```
