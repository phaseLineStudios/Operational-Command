extends BaseMilSymbolIcon
## Armored Icon.

func get_type() -> MilSymbol.UnitType:
	return MilSymbol.UnitType.ENGINEER

func _get_default_icon() -> Dictionary:
	return {
		"type": "lines",
		"paths":
		[
			[Vector2(60, 118), Vector2(60, 83), Vector2(140, 83), Vector2(140, 118)],
			[Vector2(100, 83), Vector2(100, 110)]
		]
	}
