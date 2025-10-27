extends Node
## Example usage of UnitSymbolGenerator.
##
## Demonstrates how to generate APP-6C military symbols with various configurations.

@onready var container: HBoxContainer = %HBoxContainer


func _ready() -> void:
	_generate_example_symbols.call_deferred()


## Generate example symbols showing different configurations.
func _generate_example_symbols() -> void:
	var generator := UnitSymbolGenerator.new()

	# Example 1: Friendly infantry platoon
	var symbol1 := await generator.generate(
		UnitSymbolGenerator.Affiliation.FRIEND,
		"infantry",
		UnitSymbolGenerator.Echelon.PLATOON,
		UnitSymbolGenerator.Status.PRESENT
	)
	_add_symbol_to_display(symbol1, "Friendly Infantry\nPlatoon")

	# Example 2: Enemy armor company
	var symbol2 := await generator.generate(
		UnitSymbolGenerator.Affiliation.ENEMY,
		"armor",
		UnitSymbolGenerator.Echelon.COMPANY,
		UnitSymbolGenerator.Status.PRESENT
	)
	_add_symbol_to_display(symbol2, "Enemy Armor\nCompany")

	# Example 3: Friendly artillery battalion HQ
	var symbol3 := await generator.generate(
		UnitSymbolGenerator.Affiliation.FRIEND,
		"artillery",
		UnitSymbolGenerator.Echelon.BATTALION,
		UnitSymbolGenerator.Status.PRESENT,
		UnitSymbolGenerator.Modifier.NONE,
		true,  # is_hq
		false  # is_task_force
	)
	_add_symbol_to_display(symbol3, "Friendly Artillery\nBattalion HQ")

	# Example 4: Enemy reinforced brigade (planned)
	var symbol4 := await generator.generate(
		UnitSymbolGenerator.Affiliation.ENEMY,
		"infantry",
		UnitSymbolGenerator.Echelon.BRIGADE,
		UnitSymbolGenerator.Status.PLANNED,
		UnitSymbolGenerator.Modifier.REINFORCED
	)
	_add_symbol_to_display(symbol4, "Enemy Infantry\nBrigade (+) Planned")

	# Example 5: Friendly reconnaissance task force
	var symbol5 := await generator.generate(
		UnitSymbolGenerator.Affiliation.FRIEND,
		"reconnaissance",
		UnitSymbolGenerator.Echelon.COMPANY,
		UnitSymbolGenerator.Status.PRESENT,
		UnitSymbolGenerator.Modifier.NONE,
		false,  # is_hq
		true  # is_task_force
	)
	_add_symbol_to_display(symbol5, "Friendly Recon\nCompany (TF)")

	# Example 6: Enemy reduced engineer platoon
	var symbol6 := await generator.generate(
		UnitSymbolGenerator.Affiliation.ENEMY,
		"engineer",
		UnitSymbolGenerator.Echelon.PLATOON,
		UnitSymbolGenerator.Status.PRESENT,
		UnitSymbolGenerator.Modifier.REDUCED
	)
	_add_symbol_to_display(symbol6, "Enemy Engineer\nPlatoon (-)")

	# Example 7: Friendly aviation squadron
	var symbol7 := await generator.generate(
		UnitSymbolGenerator.Affiliation.FRIEND,
		"aviation",
		UnitSymbolGenerator.Echelon.BATTALION,
		UnitSymbolGenerator.Status.PRESENT
	)
	_add_symbol_to_display(symbol7, "Friendly Aviation\nSquadron")

	# Example 8: Custom unit type (requires registration)
	generator.register_icon("mechanized", _draw_mechanized_icon)
	var symbol8 := await generator.generate(
		UnitSymbolGenerator.Affiliation.FRIEND, "mechanized", UnitSymbolGenerator.Echelon.COMPANY
	)
	_add_symbol_to_display(symbol8, "Friendly Mechanized\nCompany")


## Add symbol to display container.
## [param texture] Symbol texture.
## [param label_text] Label text.
func _add_symbol_to_display(texture: ImageTexture, label_text: String) -> void:
	var vbox := VBoxContainer.new()

	var texture_rect := TextureRect.new()
	texture_rect.texture = texture
	texture_rect.custom_minimum_size = Vector2(128, 128)
	texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_CENTERED

	var label := Label.new()
	label.text = label_text
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

	vbox.add_child(texture_rect)
	vbox.add_child(label)

	if container:
		container.add_child(vbox)


## Example custom icon: mechanized infantry (rectangle outline with diagonal).
## [param img] Image.
## [param center] Center position.
## [param size] Icon size.
func _draw_mechanized_icon(img: Image, center: Vector2, size: float) -> void:
	var half := size / 2.0
	var generator := UnitSymbolGenerator.new()

	# Draw rectangle outline (vehicle/APC body)
	var rect_w := half * 0.8
	var rect_h := half * 0.5
	var thickness := 3.0

	# Top edge
	generator._draw_thick_line(
		img,
		Vector2(center.x - rect_w, center.y - rect_h),
		Vector2(center.x + rect_w, center.y - rect_h),
		UnitSymbolGenerator.COLOR_FRAME,
		thickness
	)
	# Bottom edge
	generator._draw_thick_line(
		img,
		Vector2(center.x - rect_w, center.y + rect_h),
		Vector2(center.x + rect_w, center.y + rect_h),
		UnitSymbolGenerator.COLOR_FRAME,
		thickness
	)
	# Left edge
	generator._draw_thick_line(
		img,
		Vector2(center.x - rect_w, center.y - rect_h),
		Vector2(center.x - rect_w, center.y + rect_h),
		UnitSymbolGenerator.COLOR_FRAME,
		thickness
	)
	# Right edge
	generator._draw_thick_line(
		img,
		Vector2(center.x + rect_w, center.y - rect_h),
		Vector2(center.x + rect_w, center.y + rect_h),
		UnitSymbolGenerator.COLOR_FRAME,
		thickness
	)

	# Draw diagonal line (infantry element)
	generator._draw_thick_line(
		img,
		Vector2(center.x - half * 0.7, center.y + half * 0.7),
		Vector2(center.x + half * 0.7, center.y - half * 0.7),
		UnitSymbolGenerator.COLOR_FRAME,
		3.0
	)
