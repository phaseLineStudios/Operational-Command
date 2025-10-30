extends BaseMilSymbolIcon
## Infantry Icon.

func get_type() -> MilSymbol.UnitType:
	return MilSymbol.UnitType.HQ

func _get_friendly_icon() -> Dictionary:
	return {
		"type": "lines", 
		"paths": [
			[Vector2(25, 80), Vector2(175, 80)]
		]
	}

func _get_enemy_icon() -> Dictionary:
	return {
		"type": "lines", 
		"paths": [
			[Vector2(50, 80), Vector2(150, 80)]
		]
	}

func _get_neutral_icon() -> Dictionary:
	return {
		"type": "lines", 
		"paths": [
			[Vector2(45, 80), Vector2(155, 80)]
		]
	}

func _get_default_icon() -> Dictionary:
	return {
		"type": "lines", 
		"paths": [
			[Vector2(35, 80), Vector2(165, 80)]
		]
	}
