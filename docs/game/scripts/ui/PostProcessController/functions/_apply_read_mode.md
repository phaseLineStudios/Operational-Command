# PostProcessController::_apply_read_mode Function Reference

*Defined at:* `scripts/ui/PostProcessController.gd` (lines 136–201)</br>
*Belongs to:* [PostProcessController](../../PostProcessController.md)

**Signature**

```gdscript
func _apply_read_mode(enabled: bool) -> void
```

## Source

```gdscript
func _apply_read_mode(enabled: bool) -> void:
	if enabled == _read_mode_cached:
		return
	_read_mode_cached = enabled

	if enabled:
		_saved_settings = {
			"film_grain": film_grain,
			"grain_amount": grain_amount,
			"grain_size": grain_size,
			"vignette": vignette,
			"vignette_intensity": vignette_intensity,
			"vignette_softness": vignette_softness,
			"glow": glow,
			"glow_intensity": glow_intensity,
			"glow_bloom": glow_bloom,
			"ca": ca,
			"ca_intensity": ca_intensity,
			"sharpen": sharpen,
			"sharpen_strength": sharpen_strength,
		}

		if read_mode_disable_film_grain:
			film_grain = false
			grain_amount = 0.0
		if read_mode_disable_vignette:
			vignette = false
			vignette_intensity = 0.0
		if read_mode_disable_glow:
			glow = false
			glow_intensity = 0.0
			glow_bloom = 0.0
		if read_mode_disable_chromatic_aberration:
			ca = false
			ca_intensity = 0.0
		if read_mode_sharpen_strength > 0.0:
			sharpen = true
			sharpen_strength = read_mode_sharpen_strength

		if read_mode_force_full_res:
			_save_video_state()
			_apply_video_full_res()
	else:
		if not _saved_settings.is_empty():
			film_grain = bool(_saved_settings.get("film_grain", film_grain))
			grain_amount = float(_saved_settings.get("grain_amount", grain_amount))
			grain_size = float(_saved_settings.get("grain_size", grain_size))
			vignette = bool(_saved_settings.get("vignette", vignette))
			vignette_intensity = float(
				_saved_settings.get("vignette_intensity", vignette_intensity)
			)
			vignette_softness = float(_saved_settings.get("vignette_softness", vignette_softness))
			glow = bool(_saved_settings.get("glow", glow))
			glow_intensity = float(_saved_settings.get("glow_intensity", glow_intensity))
			glow_bloom = float(_saved_settings.get("glow_bloom", glow_bloom))
			ca = bool(_saved_settings.get("ca", ca))
			ca_intensity = float(_saved_settings.get("ca_intensity", ca_intensity))
			sharpen = bool(_saved_settings.get("sharpen", sharpen))
			sharpen_strength = float(_saved_settings.get("sharpen_strength", sharpen_strength))
			_saved_settings.clear()

		_restore_video_state()

	_apply_settings()
```
