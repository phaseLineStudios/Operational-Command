# MilSymbolTest::_generate_symbols Function Reference

*Defined at:* `scripts/test/MilSymbolTest.gd` (lines 85–139)</br>
*Belongs to:* [MilSymbolTest](../../MilSymbolTest.md)

**Signature**

```gdscript
func _generate_symbols() -> void
```

## Description

Generate all test symbols and display them in a grid

## Source

```gdscript
func _generate_symbols() -> void:
	if not u_frame.button_pressed:
		fr_preview.modulate = Color.WHITE
		fr_preview.texture = await generator.generate(
			MilSymbol.UnitAffiliation.FRIEND, u_type.selected, u_size.selected, u_designation.text
		)
		eny_preview.modulate = Color.WHITE
		eny_preview.texture = await generator.generate(
			MilSymbol.UnitAffiliation.ENEMY, u_type.selected, u_size.selected, u_designation.text
		)
		neu_preview.modulate = Color.WHITE
		neu_preview.texture = await generator.generate(
			MilSymbol.UnitAffiliation.NEUTRAL, u_type.selected, u_size.selected, u_designation.text
		)
		unk_preview.modulate = Color.WHITE
		unk_preview.texture = await generator.generate(
			MilSymbol.UnitAffiliation.UNKNOWN, u_type.selected, u_size.selected, u_designation.text
		)
	else:
		var frame_colors := MilSymbolConfig.get_frame_colors()
		fr_preview.modulate = frame_colors[MilSymbol.UnitAffiliation.FRIEND]
		fr_preview.texture = await MilSymbol.create_frame_symbol(
			MilSymbol.UnitAffiliation.FRIEND,
			u_type.selected,
			MilSymbolConfig.Size.MEDIUM,
			u_size.selected,
			u_designation.text
		)
		eny_preview.modulate = frame_colors[MilSymbol.UnitAffiliation.ENEMY]
		eny_preview.texture = await MilSymbol.create_frame_symbol(
			MilSymbol.UnitAffiliation.ENEMY,
			u_type.selected,
			MilSymbolConfig.Size.MEDIUM,
			u_size.selected,
			u_designation.text
		)
		neu_preview.modulate = frame_colors[MilSymbol.UnitAffiliation.NEUTRAL]
		neu_preview.texture = await MilSymbol.create_frame_symbol(
			MilSymbol.UnitAffiliation.NEUTRAL,
			u_type.selected,
			MilSymbolConfig.Size.MEDIUM,
			u_size.selected,
			u_designation.text
		)
		unk_preview.modulate = frame_colors[MilSymbol.UnitAffiliation.UNKNOWN]
		unk_preview.texture = await MilSymbol.create_frame_symbol(
			MilSymbol.UnitAffiliation.UNKNOWN,
			u_type.selected,
			MilSymbolConfig.Size.MEDIUM,
			u_size.selected,
			u_designation.text
		)
	generator.cleanup()
```
