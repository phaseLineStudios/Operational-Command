# TimerController::_setup_lcd_display Function Reference

*Defined at:* `scripts/core/TimerController.gd` (lines 371–443)</br>
*Belongs to:* [TimerController](../../TimerController.md)

**Signature**

```gdscript
func _setup_lcd_display() -> void
```

## Description

Setup LCD display using SubViewport.

## Source

```gdscript
func _setup_lcd_display() -> void:
	if timer == null:
		push_warning("TimerController: Timer reference not set for LCD")
		return

	# Find the MeshInstance3D in the timer
	var mesh_instance := _find_mesh_instance(timer)
	if mesh_instance == null:
		push_warning("TimerController: No MeshInstance3D found for LCD display")
		return

	# Create SubViewport for rendering LCD content
	_lcd_viewport = SubViewport.new()
	_lcd_viewport.size = lcd_resolution
	_lcd_viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	_lcd_viewport.transparent_bg = false
	add_child(_lcd_viewport)

	# Create background ColorRect
	var bg := ColorRect.new()
	bg.color = lcd_bg_color
	bg.size = Vector2(lcd_resolution)
	_lcd_viewport.add_child(bg)

	# Create label for time display (left side)
	_lcd_label = Label.new()

	# Use LabelSettings for better controld
	var label_settings := LabelSettings.new()
	label_settings.font = lcd_font
	label_settings.font_size = lcd_font_size
	label_settings.font_color = lcd_text_color

	# Apply letter spacing if supported by font variation
	if lcd_letter_spacing != 0 and lcd_font:
		# Create a font variation with spacing adjustment
		var font_variation := FontVariation.new()
		font_variation.base_font = lcd_font
		font_variation.spacing_glyph = lcd_letter_spacing
		label_settings.font = font_variation

	_lcd_label.label_settings = label_settings
	_lcd_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	_lcd_label.vertical_alignment = VERTICAL_ALIGNMENT_TOP
	_lcd_label.position = Vector2(35, 5)
	_lcd_label.size = Vector2(lcd_resolution.x - 60, lcd_resolution.y - 10)
	_lcd_viewport.add_child(_lcd_label)

	# Create icon display (right side)
	_lcd_icon = TextureRect.new()
	_lcd_icon.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
	_lcd_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	_lcd_icon.modulate = lcd_text_color  # Tint icon to match text color
	_lcd_icon.size = icon_size
	# Position at top right with 5px margin
	_lcd_icon.position = Vector2(lcd_resolution.x - icon_size.x - 15, 0)
	_lcd_viewport.add_child(_lcd_icon)

	# Create material using viewport texture
	var lcd_material := StandardMaterial3D.new()
	var viewport_tex := _lcd_viewport.get_texture()
	lcd_material.albedo_texture = viewport_tex
	lcd_material.texture_filter = BaseMaterial3D.TEXTURE_FILTER_LINEAR
	lcd_material.uv1_scale = Vector3(1.0, 1.0, 1.0)
	lcd_material.emission_enabled = true
	lcd_material.emission_texture = viewport_tex
	lcd_material.emission_energy_multiplier = 2.0
	lcd_material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED

	# Apply to surface
	mesh_instance.set_surface_override_material(lcd_surface_index, lcd_material)
```
