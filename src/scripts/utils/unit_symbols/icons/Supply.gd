extends BaseMilSymbolIcon
## Infantry Icon.


func get_type() -> MilSymbol.UnitType:
	return MilSymbol.UnitType.SUPPLY


func _get_friendly_icon() -> Dictionary:
	return {"type": "lines", "paths": [[Vector2(25, 120), Vector2(175, 120)]]}


func _get_enemy_icon() -> Dictionary:
	return {"type": "lines", "paths": [[Vector2(50, 120), Vector2(150, 120)]]}


func _get_neutral_icon() -> Dictionary:
	return {"type": "lines", "paths": [[Vector2(45, 120), Vector2(155, 120)]]}


func _get_default_icon() -> Dictionary:
	return {"type": "lines", "paths": [[Vector2(35, 120), Vector2(165, 120)]]}
