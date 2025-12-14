# UnitCreateDialog::_generate_preview_icons Function Reference

*Defined at:* `scripts/editors/UnitCreateDialog.gd` (lines 301–326)</br>
*Belongs to:* [UnitCreateDialog](../../UnitCreateDialog.md)

**Signature**

```gdscript
func _generate_preview_icons(_idx: int) -> void
```

## Source

```gdscript
func _generate_preview_icons(_idx: int) -> void:
	var fr_icon := await MilSymbol.create_symbol(
		MilSymbol.UnitAffiliation.FRIEND,
		_type_ob.selected,
		MilSymbolConfig.Size.MEDIUM,
		_size_ob.selected
	)

	var eny_icon := await MilSymbol.create_symbol(
		MilSymbol.UnitAffiliation.ENEMY,
		_type_ob.selected,
		MilSymbolConfig.Size.MEDIUM,
		_size_ob.selected
	)
	var neu_icon := await MilSymbol.create_symbol(
		MilSymbol.UnitAffiliation.NEUTRAL,
		_type_ob.selected,
		MilSymbolConfig.Size.MEDIUM,
		_size_ob.selected
	)

	_icon_fr_preview.texture = fr_icon
	_icon_eny_preview.texture = eny_icon
	_icon_neu_preview.texture = neu_icon
```
