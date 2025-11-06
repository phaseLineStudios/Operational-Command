extends BaseMilSymbolIcon
## Infantry Icon.


func get_type() -> MilSymbol.UnitType:
	return MilSymbol.UnitType.MEDICAL


func _get_friendly_icon() -> Dictionary:
	return {
		"type": "lines",
		"paths": [[Vector2(25, 100), Vector2(175, 100)], [Vector2(100, 50), Vector2(100, 150)]]
	}


func _get_enemy_icon() -> Dictionary:
	return {
		"type": "lines",
		"paths": [[Vector2(28, 100), Vector2(172, 100)], [Vector2(100, 28), Vector2(100, 172)]]
	}


func _get_default_icon() -> Dictionary:
	return {
		"type": "lines",
		"paths": [[Vector2(45, 100), Vector2(155, 100)], [Vector2(100, 45), Vector2(100, 155)]]
	}
