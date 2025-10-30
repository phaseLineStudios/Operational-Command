extends BaseMilSymbolIcon
## Armored Icon.


func get_type() -> MilSymbol.UnitType:
	return MilSymbol.UnitType.ANTI_AIR


func _get_default_icon() -> Dictionary:
	return {
		"type": "lines",
		"paths":
		[
			[Vector2(100, 80), Vector2(100, 120)],
			[Vector2(92, 90), Vector2(92, 110)],
			[Vector2(108, 90), Vector2(108, 110)]
		]
	}
