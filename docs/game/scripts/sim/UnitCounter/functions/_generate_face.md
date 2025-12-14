# UnitCounter::_generate_face Function Reference

*Defined at:* `scripts/sim/UnitCounter.gd` (lines 104–156)</br>
*Belongs to:* [UnitCounter](../../UnitCounter.md)

**Signature**

```gdscript
func _generate_face(color: Color) -> Texture2D
```

## Source

```gdscript
func _generate_face(color: Color) -> Texture2D:
	var key := _face_cache_key(affiliation, callsign, symbol_type, symbol_size, color)
	var cached: Variant = _face_texture_cache.get(key, null)
	if cached is Texture2D:
		_maybe_free_face_renderer()
		return cached

	# Create frame-only symbol (white lines) using enum-based API
	var config := MilSymbolConfig.create_frame_only()
	config.size = MilSymbolConfig.Size.LARGE
	config.resolution_scale = 4.0  # High quality for counter face

	var generator := MilSymbol.new(config)
	var mil_affiliation := _counter_to_mil_affiliation(affiliation)
	var unit_symbol := await generator.generate(mil_affiliation, symbol_type, symbol_size, "")
	generator.cleanup()

	# Setup the face elements
	face_symbol.texture = unit_symbol
	face_symbol.modulate = Color(0.0, 0.0, 0.0)
	face_callsign.text = callsign

	# Set background color (duplicate to avoid sharing between counters)
	var sb: StyleBoxFlat = face_background.get_theme_stylebox("panel").duplicate()
	sb.bg_color = color
	face_background.add_theme_stylebox_override("panel", sb)

	# Update the (disabled-by-default) viewport once to bake the face texture.
	if face_renderer:
		face_renderer.render_target_update_mode = SubViewport.UPDATE_ONCE

	# Wait for viewport to render
	await get_tree().process_frame
	await get_tree().process_frame

	if face_renderer == null:
		LogService.warning("UnitCounter: FaceRenderer missing", "UnitCounter.gd")
		return unit_symbol

	var img := face_renderer.get_texture().get_image()
	img.generate_mipmaps()

	var tex: Texture2D = ImageTexture.create_from_image(img)
	_face_texture_cache[key] = tex
	_face_cache_order.append(key)
	if _face_cache_order.size() > _FACE_CACHE_MAX_ENTRIES:
		var old_key: String = _face_cache_order.pop_front()
		_face_texture_cache.erase(old_key)

	_maybe_free_face_renderer()
	return tex
```
