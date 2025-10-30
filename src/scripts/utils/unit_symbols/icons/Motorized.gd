extends BaseMilSymbolIcon
## Motorized Icon.

func get_type() -> MilSymbol.UnitType:
	return MilSymbol.UnitType.MOTORIZED

func _get_friendly_icon() -> Dictionary:
	return {
		"type": "lines",
		"paths": [
			[Vector2(25, 50), Vector2(175, 150)],
			[Vector2(25, 150), Vector2(175, 50)],
			[Vector2(100, 50), Vector2(100, 150)]
		]
	}

func _get_enemy_icon() -> Dictionary:
	return {
		"type": "lines",
		"paths": [
			[Vector2(64, 64), Vector2(136, 136)],
			[Vector2(64, 136), Vector2(136, 64)],
			[Vector2(100, 28), Vector2(100, 172)]
		]
	}

func _get_default_icon() -> Dictionary:
	return {
		"type": "lines",
		"paths": [
			[Vector2(45, 45), Vector2(155, 155)],
			[Vector2(45, 155), Vector2(155, 45)],
			[Vector2(100, 45), Vector2(100, 155)]
		]
	}
