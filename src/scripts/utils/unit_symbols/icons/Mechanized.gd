extends BaseMilSymbolIcon
## Mechanized Icon.

func get_type() -> MilSymbol.UnitType:
	return MilSymbol.UnitType.MECHANIZED

func get_icon_config(
	affiliation: MilSymbol.UnitAffiliation
) -> Dictionary:
	match affiliation:
		MilSymbol.UnitAffiliation.FRIEND:
			return {
				"type": "mixed",
				"shapes":
				[
					{
						"shape": "rect",
						"rect": Rect2(60, 79, 82, 44),
						"corner_radius": 19.5,
						"filled": false
					}
				],
				"paths":
				[[Vector2(25, 50), Vector2(175, 150)], [Vector2(25, 150), Vector2(175, 50)]]
			}
		MilSymbol.UnitAffiliation.ENEMY:
			return {
				"type": "mixed",
				"shapes":
				[
					{
						"shape": "rect",
						"rect": Rect2(60, 79, 82, 44),
						"corner_radius": 19.5,
						"filled": false
					}
				],
				"paths":
				[[Vector2(64, 64), Vector2(136, 136)], [Vector2(64, 136), Vector2(136, 64)]]
			}
		_:
			return {
				"type": "mixed",
				"shapes":
				[
					{
						"shape": "rect",
						"rect": Rect2(60, 79, 82, 44),
						"corner_radius": 19.5,
						"filled": false
					}
				],
				"paths":
				[[Vector2(45, 45), Vector2(155, 155)], [Vector2(155, 45), Vector2(45, 155)]]
			}
