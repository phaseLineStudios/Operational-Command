extends BaseMilSymbolIcon
## Infantry Icon.

func get_type() -> MilSymbol.UnitType:
	return MilSymbol.UnitType.ANTI_TANK

func _get_friendly_icon() -> Dictionary:
	return {
		"type": "lines",
		"paths":
		[
			[Vector2(25, 150), Vector2(100, 52)],  # Left line
			[Vector2(175, 150), Vector2(100, 52)]  # Right line
		]
	}

func _get_enemy_icon() -> Dictionary:
	return {
		"type": "lines",
		"paths":
		[
			[Vector2(60, 132), Vector2(100, 30)],  # Left line
			[Vector2(140, 132), Vector2(100, 30)]  # Right line
		]
	}

func _get_neutral_icon() -> Dictionary:
	return {
		"type": "lines",
		"paths":
		[
			[Vector2(45, 150), Vector2(100, 47)],  # Left line
			[Vector2(155, 150), Vector2(100, 47)]  # Right line
		]
	}

func _get_unknown_icon() -> Dictionary:
	return {
		"type": "lines",
		"paths":
		[
			[Vector2(55, 135), Vector2(100, 33)],  # Left line
			[Vector2(145, 135), Vector2(100, 33)]  # Right line
		]
	}
