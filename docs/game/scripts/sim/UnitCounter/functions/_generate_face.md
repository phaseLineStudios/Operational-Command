# UnitCounter::_generate_face Function Reference

*Defined at:* `scripts/sim/UnitCounter.gd` (lines 59–89)</br>
*Belongs to:* [UnitCounter](../../UnitCounter.md)

**Signature**

```gdscript
func _generate_face(color: Color) -> Texture2D
```

## Source

```gdscript
func _generate_face(color: Color) -> Texture2D:
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

	# Wait for viewport to render
	await get_tree().process_frame
	await get_tree().process_frame

	var img := face_renderer.get_texture().get_image()
	img.generate_mipmaps()

	return ImageTexture.create_from_image(img)
```
