## Test script for MilSymbol generator
## Demonstrates how to create and display military symbols
extends Node2D

## Grid layout settings
const SYMBOLS_PER_ROW: int = 4
const SYMBOL_SPACING: int = 150

## Test data for symbols to generate
var test_symbols: Array[Dictionary] = [
	{
		"affiliation": MilSymbol.UnitAffiliation.FRIEND,
		"type": MilSymbol.UnitType.INFANTRY,
		"size": MilSymbol.UnitSize.COMPANY,
		"designation": "A/1-5"
	},
	{
		"affiliation": MilSymbol.UnitAffiliation.FRIEND,
		"type": MilSymbol.UnitType.ARMOR,
		"size": MilSymbol.UnitSize.BATTALION,
		"designation": "1-67"
	},
	{
		"affiliation": MilSymbol.UnitAffiliation.ENEMY,
		"type": MilSymbol.UnitType.MECHANIZED,
		"size": MilSymbol.UnitSize.COMPANY,
		"designation": "2BTN"
	},
	{
		"affiliation": MilSymbol.UnitAffiliation.ENEMY,
		"type": MilSymbol.UnitType.ARTILLERY,
		"size": MilSymbol.UnitSize.BATTALION,
		"designation": "251"
	},
	{
		"affiliation": MilSymbol.UnitAffiliation.NEUTRAL,
		"type": MilSymbol.UnitType.RECON,
		"size": MilSymbol.UnitSize.PLATOON,
		"designation": "RECON"
	},
	{
		"affiliation": MilSymbol.UnitAffiliation.UNKNOWN,
		"type": MilSymbol.UnitType.ENGINEER,
		"size": MilSymbol.UnitSize.COMPANY,
		"designation": "ENG"
	},
	{
		"affiliation": MilSymbol.UnitAffiliation.FRIEND,
		"type": MilSymbol.UnitType.ANTI_TANK,
		"size": MilSymbol.UnitSize.PLATOON,
		"designation": "AT"
	},
	{
		"affiliation": MilSymbol.UnitAffiliation.FRIEND,
		"type": MilSymbol.UnitType.ANTI_AIR,
		"size": MilSymbol.UnitSize.PLATOON,
		"designation": "AA"
	},
	{
		"affiliation": MilSymbol.UnitAffiliation.FRIEND,
		"type": MilSymbol.UnitType.HQ,
		"size": MilSymbol.UnitSize.COMPANY,
		"designation": "HQ"
	}
]


func _ready() -> void:
	# Create title
	var title_label := Label.new()
	title_label.text = "Military Symbol Generator - Test Display"
	title_label.position = Vector2(20, 20)
	title_label.add_theme_font_size_override("font_size", 24)
	add_child(title_label)

	# Generate and display symbols
	await _generate_symbols()


## Generate all test symbols and display them in a grid
func _generate_symbols() -> void:
	var config := MilSymbolConfig.create_default()
	config.size = MilSymbolConfig.Size.MEDIUM
	var generator := MilSymbol.new(config)

	var row := 0
	var col := 0

	for symbol_data in test_symbols:
		# Generate the symbol texture using enums
		var texture := await generator.generate(
			symbol_data["affiliation"],
			symbol_data["type"],
			symbol_data["size"],
			symbol_data["designation"]
		)

		# Create a Sprite2D to display it
		var sprite := Sprite2D.new()
		sprite.texture = texture
		sprite.position = Vector2(100 + col * SYMBOL_SPACING, 100 + row * SYMBOL_SPACING)
		add_child(sprite)

		# Add label below
		var label := Label.new()
		var aff_name: String = MilSymbol.UnitAffiliation.keys()[symbol_data["affiliation"]]
		var type_name: String = MilSymbol.UnitType.keys()[symbol_data["type"]]
		label.text = "%s\n%s" % [aff_name, type_name]
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.position = sprite.position + Vector2(-50, 80)
		label.size = Vector2(100, 50)
		add_child(label)

		# Update grid position
		col += 1
		if col >= SYMBOLS_PER_ROW:
			col = 0
			row += 1

	generator.cleanup()

	print("Generated %d military symbols" % test_symbols.size())


## Example: Generate a single symbol
func _example_single_symbol() -> void:
	var config := MilSymbolConfig.create_default()
	config.size = MilSymbolConfig.Size.LARGE

	var generator := MilSymbol.new(config)

	# Generate a friendly infantry company symbol
	var texture := await generator.generate_texture(
		MilSymbolConfig.Affiliation.FRIEND,
		MilSymbolGeometry.Domain.GROUND,
		MilSymbolIcons.IconType.INFANTRY,
		"II",  # Company size
		"A/1-5"  # Designation
	)

	# Use the texture
	var sprite := Sprite2D.new()
	sprite.texture = texture
	add_child(sprite)

	generator.cleanup()


## Example: Generate from simple code
func _example_code_generation() -> void:
	var generator := MilSymbol.new()

	# "F-G-INF" = Friend, Ground, Infantry
	var texture := await generator.generate_from_code("F-G-INF", "III", "2-14")

	var sprite := Sprite2D.new()
	sprite.texture = texture
	add_child(sprite)

	generator.cleanup()


## Example: Using the static convenience method
func _example_static_method() -> void:
	var texture := await MilSymbol.create_symbol(
		MilSymbol.UnitAffiliation.FRIEND,
		MilSymbol.UnitType.ARMOR,
		MilSymbolConfig.Size.MEDIUM,
		MilSymbol.UnitSize.BATTALION,
		"1-67"
	)

	var sprite := Sprite2D.new()
	sprite.texture = texture
	add_child(sprite)


## Example: Frame-only symbols (no fill)
func _example_frame_only() -> void:
	# Method 1: Use the static convenience method
	var texture1 := await MilSymbol.create_frame_symbol(
		MilSymbol.UnitAffiliation.ENEMY,
		MilSymbol.UnitType.MECHANIZED,
		MilSymbolConfig.Size.MEDIUM,
		MilSymbol.UnitSize.BATTALION,
		"251"
	)

	var sprite1 := Sprite2D.new()
	sprite1.texture = texture1
	sprite1.position = Vector2(100, 100)
	add_child(sprite1)

	# Method 2: Use the frame-only configuration preset
	var config := MilSymbolConfig.create_frame_only()
	config.size = MilSymbolConfig.Size.LARGE
	config.stroke_width = 5.0  # Thicker outline for visibility

	var generator := MilSymbol.new(config)
	var texture2 := await generator.generate(
		MilSymbol.UnitAffiliation.FRIEND,
		MilSymbol.UnitType.ARMOR,
		MilSymbol.UnitSize.COMPANY,
		"A-67"
	)

	var sprite2 := Sprite2D.new()
	sprite2.texture = texture2
	sprite2.position = Vector2(300, 100)
	add_child(sprite2)

	generator.cleanup()
